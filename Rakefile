require 'rake'
require 'rdoc/task'
require 'rake/testtask'
require 'rake/clean'

NAME = "sparql-doc"
VER = "0.0.1"

RDOC_OPTS = ['--quiet', '--title', 'SPARQL Doc Reference', '--main', 'README']

PKG_FILES = %w( README.md Rakefile ) + 
  Dir.glob("{bin,tests,lib}/**/*")

CLEAN.include ['*.gem', 'pkg']  
#SPEC =
#  Gem::Specification.new do |s|
#    s.name = NAME
#    s.version = VER
#    s.platform = Gem::Platform::RUBY
#    s.required_ruby_version = ">= 1.9.3"    
#    s.has_rdoc = true
#    s.extra_rdoc_files = ["README.md"]
#    s.rdoc_options = RDOC_OPTS
#    s.summary = "dowl OWL/RDF doc generator"
#    s.description = s.summary
#    s.author = "Leigh Dodds"
#    s.email = 'leigh@ldodds.com'
#    s.homepage = 'http://github.com/ldodds/sparql-doc'
#    s.files = PKG_FILES
#    s.require_path = "lib" 
#    s.bindir = "bin"
#    s.executables = ["sparql-doc"]
#    s.test_file = "tests/ts_sparql_doc.rb"
#    s.add_dependency("json")
#    s.add_dependency("redcarpet")
#  end
#      
#Rake::GemPackageTask.new(SPEC) do |pkg|
#    pkg.need_tar = true
#end

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
    rdoc.main = "README.md"
    
end

Rake::TestTask.new do |test|
  test.test_files = FileList['tests/tc_*.rb']
end

desc "Install from a locally built copy of the gem"
task :install do
  sh %{rake package}
  sh %{sudo gem install --no-ri --no-rdoc pkg/#{NAME}-#{VER}}
end

desc "Uninstall the gem"
task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
