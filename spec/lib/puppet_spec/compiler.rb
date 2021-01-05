module PuppetSpec::Compiler
  module_function

  def compile_to_catalog(string, node = Puppet::Node.new('test'))
    Puppet[:code] = string
    # see lib/puppet/indirector/catalog/compiler.rb#filter
    Puppet::Parser::Compiler.compile(node).filter { |r| r.virtual? }
  end

  def compile_to_ral(manifest, node = Puppet::Node.new('test'))
    catalog = compile_to_catalog(manifest, node)
    ral = catalog.to_ral
    ral.finalize
    ral
  end

  def apply_compiled_manifest(manifest, prioritizer = Puppet::Graph::SequentialPrioritizer.new)
    args = []
    if Puppet.version.to_f < 5.0
      args << 'apply'
      # rubocop:disable RSpec/AnyInstance
      Puppet::Transaction::Persistence.any_instance.stubs(:save)
      # rubocop:enable RSpec/AnyInstance
    end
    catalog = compile_to_ral(manifest)
    if block_given?
      catalog.resources.each { |res| yield res }
    end
    transaction = Puppet::Transaction.new(catalog,
                                          Puppet::Transaction::Report.new(*args),
                                          prioritizer)
    transaction.evaluate
    transaction.report.finalize_report

    transaction
  end

  def apply_with_error_check(manifest)
    apply_compiled_manifest(manifest) do |res|
      res.expects(:err).never
    end
  end
end
