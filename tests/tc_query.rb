$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'sparql-doc'
require 'test/unit'

class QueryTest < Test::Unit::TestCase
  
  def test_basic    
    query = SparqlDoc::Query.new("/path/to/query.rq", "DESCRIBE ?x")
    assert_equal("/path/to/query.rq", query.title)
    assert_equal("", query.description)
    assert_equal({}, query.prefixes)
    assert_equal([], query.see)
    assert_equal([], query.tag)
    assert_equal([], query.author)
    assert_equal([], query.endpoint)
    assert_equal([], query.param)
    assert_equal("DESCRIBE ?x", query.query)  
    assert_equal("DESCRIBE ?x", query.raw_query)
    assert_equal("DESCRIBE+%3Fx", query.query_string)
    assert_equal("DESCRIBE", query.type)
  end

  def test_type    
    query = SparqlDoc::Query.new("/path/to/query.rq", "describe ?x")
    assert_equal("DESCRIBE", query.type)
  end    
  
  def test_prefixes
    sparql=<<-EOL     
#Description
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
prefix foo: <http://example.org/foo>
 PREFIX bar: <http://example.org/bar>
prefix   baz  : <http://example.org/baz#>
DESCRIBE ?x
EOL
    query = SparqlDoc::Query.new("/path/to/query.rq", sparql)
    assert_equal("DESCRIBE", query.type)    
    assert_equal( 4, query.prefixes.size )
    assert_equal( "http://xmlns.com/foaf/0.1/", query.prefixes["foaf"] )
    assert_equal( "http://example.org/foo", query.prefixes["foo"] )
    assert_equal( "http://example.org/bar", query.prefixes["bar"] )
    assert_equal( "http://example.org/baz#", query.prefixes["baz"] )
  end
  
  def test_description    
    sparql=<<-EOL     
#Description
DESCRIBE ?x
EOL
    query = SparqlDoc::Query.new("/path/to/query.rq", sparql)
    assert_equal("/path/to/query.rq", query.title)
    assert_equal("Description", query.description)
    assert_equal("DESCRIBE ?x", query.query)  
    assert_equal("#Description\nDESCRIBE ?x\n", query.raw_query)
  end
  
  def test_description    
    sparql=<<-EOL     
#Description
#Over multiple
#...lines
DESCRIBE ?x
EOL
    query = SparqlDoc::Query.new("/path/to/query.rq", sparql)
    assert_equal("/path/to/query.rq", query.title)
    assert_equal("Description\nOver multiple\n...lines", query.description)
    assert_equal("DESCRIBE ?x", query.query)  
    assert_equal("#Description\n#Over multiple\n#...lines\nDESCRIBE ?x\n", query.raw_query)
  end  
  
  def test_title    
    sparql=<<-EOL     
#Description
# @title My Query    
DESCRIBE ?x
EOL
    query = SparqlDoc::Query.new("/path/to/query.rq", sparql)
    assert_equal("My Query", query.title)
    assert_equal("Description", query.description)
    assert_equal("DESCRIBE ?x", query.query)  
  end
  
  def test_all
    sparql=<<-EOL     
#Description
# @title My Query   
# @author leigh@ldodds.com
# @tag demo
# @tag test
# @see http://github.com/ldodds/sparql-doc                     
DESCRIBE ?x
EOL
    query = SparqlDoc::Query.new("/path/to/query.rq", sparql)
    assert_equal("My Query", query.title)
    assert_equal("Description", query.description)
    assert_equal("DESCRIBE ?x", query.query)  
    assert_equal(["leigh@ldodds.com"], query.author)
    assert_equal(["http://github.com/ldodds/sparql-doc"], query.see)
    assert_equal(["demo", "test"], query.tag)            
  end  

  def test_markdown    
    sparql=<<-EOL     
#Description
DESCRIBE ?x
EOL
    query = SparqlDoc::Query.new("/path/to/query.rq", sparql)
    assert_equal("<p>Description<p>", query.description(true))
    assert_equal("DESCRIBE ?x", query.query)  
  end  
  
  def test_markdown    
    sparql=<<-EOL     
#See [my website](http://example.org)
DESCRIBE ?x
EOL
    query = SparqlDoc::Query.new("/path/to/query.rq", sparql)
    assert_equal("<p>See <a href=\"http://example.org\">my website</a></p>\n", query.description(true))
    assert_equal("DESCRIBE ?x", query.query)  
  end    
    
end
