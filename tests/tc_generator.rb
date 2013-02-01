$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'sparql-doc'
require 'test/unit'
require 'fakefs/safe'

class GeneratorTest < Test::Unit::TestCase
  include FakeFS
  
  def setup
    FakeFS.activate!    
    
    FileUtils.mkdir_p("/lib/views")
    FileUtils.touch("/lib/views/index.erb")
    FileUtils.touch("/lib/views/query.erb")
    FileUtils.mkdir_p("/lib/assets")
    FileUtils.touch("/lib/assets/test.js")
    FileUtils.touch("/lib/assets/test.css")
    
    FileUtils.mkdir_p("/in")    
    
    File.open("/in/test.rq", "w") do |f|
      f.puts "DESCRIBE ?x"
    end       
    FileUtils.mkdir_p("/out")    
  end
  
  def teardown
    FakeFS.deactivate!
  end
  
  def test_copy_assets
    generator = SparqlDoc::Generator.new("/in", "/out", "/lib/views", "/lib/assets")
    generator.copy_assets()
    assert_equal( true, File.exists?("/out/test.js") )
    assert_equal( true, File.exists?("/out/test.css") )
  end
  
  def test_parse_queries
    generator = SparqlDoc::Generator.new("/in", "/out", "/lib/views", "/lib/assets")
    generator.parse_queries
    assert_equal( 1, generator.queries.size )
  end
  
  def test_parse_package
    generator = SparqlDoc::Generator.new("/in", "/out", "/lib/views", "/lib/assets")
    assert_equal( {}, generator.parse_package )
      
    File.open("/in/package.json", "w") do |f|
      f.puts "{\"title\": \"Package Title\"}"
    end    
    assert_equal( {"title"=>"Package Title"}, generator.parse_package )             
  end
  
end