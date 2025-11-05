task :test do
  require 'rake/testtask'

  Rake::TestTask.new(:test) do |t|
    t.libs << 'lib'
    t.libs << 'test'
    t.pattern = 'test/**/*_test.rb'
    t.verbose = false
  end
end

task default: :test

task :console do
  require 'analysis_tools'

  require 'irb'
  binding.irb
end
