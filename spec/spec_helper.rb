require "analysis_tools"

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.disable_monkey_patching!

  config.order = :random

  Kernel.srand(config.seed)

  config.before(:suite) do
    AnalysisTools.count_method_calls(methods_with_args: false)
  end

  config.after(:suite) do
    AnalysisTools.report
  end

end
