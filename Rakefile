# encoding: utf-8
$LOAD_PATH << "./lib/"
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require 'apigee-platform'
Jeweler::Tasks.new do |gem|
  gem.name = "apigee-platform"
  gem.homepage = "http://github.com/woodoo/apigee-platform"
  gem.license = "MIT"
  gem.summary = %Q{This is a ruby wrapper for Apigee Platform API (http://apigee.com/)}
  gem.description = gem.summary
  gem.email = "vasiliy.sablin@gmail.com"
  gem.authors = ["Vasiliy Sablin"]
  gem.version = ApigeePlatform::Version::STRING
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end
task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = ApigeePlatform::Version::STRING

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "apigee-platform #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
