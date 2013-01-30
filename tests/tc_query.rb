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
    assert_equal([], query.tags)
    assert_equal([], query.authors)
    assert_equal("DESCRIBE ?x", query.query)  
    assert_equal("DESCRIBE ?x", query.raw_query)
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
  
  def test_title    
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
    assert_equal(["leigh@ldodds.com"], query.authors)
    assert_equal(["http://github.com/ldodds/sparql-doc"], query.see)
    assert_equal(["demo", "test"], query.tags)            
  end  
  
end
