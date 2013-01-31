module SparqlDoc

  #Wrapper for SPARQL query  
  class Query
    
    attr_reader :path, :title, :query, :raw_query, :see, :tag, :author, :prefixes 

    ANNOTATIONS = {
      :author => {
        :multi => true 
      },
      :see => {
        :multi => true 
      },  
      :tag => {
        :multi => true 
      },  
      :title => {
        :multi => false 
      },
    }
        
    def initialize(path, query)
      ANNOTATIONS.each do |var, config|
        if config[:multi]
          instance_variable_set( "@#{var}", [] )
        else
          instance_variable_set( "@#{var}", "" )
        end
      end
      @path = path
      @query = query
      @raw_query = query
      @title = @path
      @description = ""
      @prefixes = {}
      initComments()
      initPrefixes()
    end
    
    def output_filename
      return "#{path.gsub(".rq", "")}.html"
    end
    
    def description(html=false)
      if html
        renderer = Redcarpet::Render::HTML.new({})
        markdown = Redcarpet::Markdown.new(renderer, {})
        return markdown.render(@description)
      end
      @description
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
            if ( matches = line.match(/^# *@([a-zA-Z]+) *(.+)$/i) )
              annotation = matches[1]
              config = ANNOTATIONS[ annotation.intern ] 
              if config
                if config[:multi]
                  val = instance_variable_get("@#{annotation}")
                  val << matches[2].strip
                else
                  instance_variable_set("@#{annotation}", matches[2].strip)
                end                
                #@title = matches[2].strip if matches[1] == "title"
                #@authors << matches[2].strip if matches[1] == "author"
                #@see << matches[2].strip if matches[1] == "see"
                #@tags << matches[2].strip if matches[1] == "tag"
                description = true
              end
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