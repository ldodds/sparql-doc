require 'rake'
require 'rdoc/task'
require 'rake/testtask'
require 'rake/clean'

CLEAN.include ['*.gem', 'pkg']

$spec = eval(File.read('sparql-doc.gemspec'))

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
    rdoc.main = "README.md"
end

Rake::TestTask.new do |test|
  test.test_files = FileList['tests/tc_*.rb']
end

task :package do
  sh %{gem build sparql-doc.gemspec}
end

task :install do
  sh %{sudo gem install --no-document sparql-doc-#{$spec.version}.gem}
end

desc "Uninstall the gem"
task :uninstall => [:clean] do
  sh %{sudo gem uninstall sparql-doc}
end
