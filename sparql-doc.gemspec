PKG_FILES = %w( README.md Rakefile ) +
  Dir.glob("{bin,tests,lib}/**/*")

RDOC_OPTS = ['--quiet', '--title', 'SPARQL Doc Reference', '--main', 'README']

Gem::Specification.new do |s|
  s.name = "sparql-doc"
  s.version = "0.0.4"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 2.7.0"
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
  s.add_development_dependency("rubocop")
end
