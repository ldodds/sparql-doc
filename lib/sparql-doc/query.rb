module SparqlDoc

  #Wrapper for SPARQL query  
  class Query
    
    attr_reader :path, :title, :query, :raw_query, :see, :tags, :authors, :prefixes 
    
    def initialize(path, query)
      @path = path
      @query = query
      @raw_query = query
      @title = @path
      @description = "";
      @authors = []    
      @see = []
      @tags = []  
      @prefixes = {}      
      initComments()
      initPrefixes()
    end
    
    def description(html=false)
      return @description unless html
    end
    
    #SELECT|CONSTRUCT|...
    def type
      ""
    end
          
    private
    
      def initPrefixes()
        
      end
      
      def initComments
        query_lines = []
        header = true
        description = false 
        description_lines = []
        @raw_query.split("\n").each do |line|
          if ( header && line.match(/^#/) )
            if ( matches = line.match(/^# *@(title|author|see|tag) *(.+)$/i) )
              @title = matches[2].strip if matches[1] == "title"
              @authors << matches[2].strip if matches[1] == "author"
              @see << matches[2].strip if matches[1] == "see"
              @tags << matches[2].strip if matches[1] == "tag"
              description = true
            else if (description == false) 
              description_lines << line[1..-1].strip
            end
          end
          else
            header = false
            query_lines << line  
          end
        end
        @description = description_lines.join("\n") unless description_lines.empty?
        @query = query_lines.join("\n") unless query_lines.empty?    
        @query.strip!              
      end
  end
end