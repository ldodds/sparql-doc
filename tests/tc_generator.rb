$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'sparql-doc'
require 'test/unit'
require 'fakefs/safe'

class GeneratorTest < Test::Unit::TestCase
  include FakeFS
  
  def setup
    FakeFS.activate!    
    FileUtils.mkdir_p("/in/views")
    FileUtils.touch("/in/views/index.erb")
    FileUtils.touch("/in/views/query.erb")
    FileUtils.mkdir_p("/in/assets")
    FileUtils.touch("/in/assets/test.js")
    FileUtils.touch("/in/assets/test.css")
    FileUtils.mkdir_p("/out")    
  end
  
  def teardown
    FakeFS.deactivate!
  end
  
  def test_copy_assets
    fs = FileSystem
    generator = SparqlDoc::Generator.new("/in", "/out", "/in/views", "/in/assets")
    generator.copy_assets()
    assert_equal( true, File.exists?("/out/test.js") )
    assert_equal( true, File.exists?("/out/test.css") )
  end
  
end