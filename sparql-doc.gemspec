PKG_FILES = %w( README.md Rakefile ) + 
  Dir.glob("{bin,tests,lib}/**/*")

RDOC_OPTS = ['--quiet', '--title', 'SPARQL Doc Reference', '--main', 'README']

Gem::Specification.new do |s|
  s.name = "sparql-doc"
  s.version = "0.0.1"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"    
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options = RDOC_OPTS
  s.summary = "SPARQL documentation generator"
  s.description = s.summary
  s.author = "Leigh Dodds"
  s.email = 'leigh@ldodds.com'
  s.homepage = 'http://github.com/ldodds/sparql-doc'
  s.files = PKG_FILES
  s.require_path = "lib" 
  s.bindir = "bin"
  s.executables = ["sparql-doc"]
  s.test_file = "tests/ts_sparql_doc.rb"
  s.add_dependency("json")
  s.add_dependency("redcarpet")
  s.add_development_dependency("fakefs")
end