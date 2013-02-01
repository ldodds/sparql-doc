module SparqlDoc

  #Wrapper for SPARQL query  
  class Query
    
    attr_reader :path, :query, :raw_query, :prefixes, :type, :package

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
      :endpoint => {
        :multi => true
      },
      :param => {
        :multi => true
      }
    }
        
    ANNOTATIONS.each do |var, config|
      attr_reader(var)
    end
    
    def initialize(path, query, package={})
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
        
      ["endpoint", "author", "tag"].each do |annotation|
        if package[annotation]
          instance_variable_set( "@#{annotation}", package[annotation])
        end
      end  
      parseQuery()
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
    
    def query_string
      CGI::escape( @query )
    end
    
    private
    
      def parseQuery
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
                description = true
              else
                $stderr.puts("Ignoring unknown annotation: @#{annotation}")
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
        query_lines.each do |line|
          if (matches = line.match(/^ *PREFIX *([a-zA-Z_-]+) *: *<(.+)>$/i) )
            @prefixes[ matches[1] ] = matches[2]
          end
          if (matches = line.match(/^ *(SELECT|CONSTRUCT|DESCRIBE|ASK) */i) )
            @type = matches[1].upcase
          end
        end              
      end
  end
end