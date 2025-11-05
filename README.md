# Ruby Analysis Tools

Analysis tools for both Rails and Ruby apps

# Usage

```ruby
# spec/spec_helper.rb

RSpec.configure do |config|
  config.before(:suite) do
    AnalysisTools.count_method_calls(methods_with_args: false)
    # and/or
    AnalysisTools.count_method_calls(methods_with_args: true)
  end

  config.after(:suite) do
    AnalysisTools.report
  end
end
```

For Minitest

```ruby
# test/test_helper.rb
AnalysisTools.count_...

Minitest.after_run do
  AnalysisTools.report
end
```
