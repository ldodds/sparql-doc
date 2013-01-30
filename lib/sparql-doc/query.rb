module SparqlDoc

  #Wrapper for SPARQL query  
  class Query
    
    def initialize(query)
      @raw_query = query
    end
    
    def description(html=false)
      ""
    end
    
    #@tag
    def tags
      []
    end
    
    #@title
    def title
      "title"
    end
    
    #@author
    def author
      "author"
    end
    
    #@see
    def see
      []
    end
      
    #PREFIX
    def schemas
      []
    end
    
    def query(raw=true)
      @raw_query
    end
    
    def header
      header = []
      @raw_query.split("\n").each do |line|
        #ignore empty lines at start
        #collect up comments at head of file
        #as soon as we get a non-empty, non-comment line, then stop looking
        if line.start_with?("#")
          header << line[0..line.length-1]
        end
      end
      header
    end
    
  end
end