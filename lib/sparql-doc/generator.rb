module SparqlDoc
  
  class Generator
    attr_reader :dir, :graph, :lenses
    
    def initialize(dir, output_dir)
      @dir = dir
      @output_dir = output_dir
      
      @queries = parse_queries()
      @queries.sort! {|x,y| x.title <=> y.title }
           
      template_dir = File.dirname( __FILE__ )
          
      @index_template = ERB.new(File.read(File.join(template_dir, "views", "index.erb")))
      @query_template = ERB.new(File.read(File.join(template_dir, "views", "query.erb")))
        
    end
    
    def parse_queries()
      queries = []
      Dir.glob("#{@dir}/*.rq") do |file|
        content = File.read(file)
        path = file.gsub("#{@dir}/", "")
        queries << SparqlDoc::Query.new(path, content)
      end
      return queries
    end
    
    def run()
      copy_assets()
      generate_index()
      generate_query_pages()
    end
  
    def copy_assets()
      $stderr.puts("Copying assets");
      asset_dir = File.join( File.dirname( __FILE__ ), "assets" )
      Dir.new(asset_dir).each() do |file|
        if file != "." and file != ".."
          FileUtils.copy( File.join(asset_dir, file), @output_dir )
        end
      end
    end
      
    def generate_index()
      $stderr.puts("Generating index.html");
      b = binding
      dir = @dir
      queries = @queries
      html = @index_template.result(b)
      File.open(File.join(@output_dir, "index.html"), "w") do |f|
        f.puts(html)
      end
    end
    
    def generate_query_pages()
      @queries.each do |query|
        $stderr.puts("Generating docs for #{query.path}")
        File.open( File.join(@output_dir, query.output_filename), "w" ) do |f|
          b = binding
          dir = @dir                          
          f.puts( @query_template.result(b) )
        end        
      end     
    end
      
  
  end
end  