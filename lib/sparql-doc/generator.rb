module SparqlDoc
  
  class Generator
    
    attr_reader :dir, :graph, :queries, :package
        
    def initialize(dir, output_dir, view_dir=nil, asset_dir=nil)
      @dir = dir
      @output_dir = output_dir                  
      @asset_dir = asset_dir || File.join( File.dirname( __FILE__ ) , "assets")     
      @view_dir = view_dir || File.join( File.dirname( __FILE__ ) , "views")
      @package = parse_package()
      @queries = parse_queries()                      
    end

    def read_template(name)
      File.read(File.join(@view_dir, "#{name}.erb"))
    end
        
    def parse_package()
      package = File.join(@dir, "package.json")
      if File.exists?(package)
        return JSON.load( File.open(package) )        
      end
      Hash.new
    end
    
    def parse_queries()
      queries = []
      Dir.glob("#{@dir}/*.rq") do |file|
        content = File.read(file)
        path = file.gsub("#{@dir}/", "")
        queries << SparqlDoc::Query.new(path, content, @package)
      end
      queries.sort! {|x,y| x.title <=> y.title }      
      queries
    end
    
    def run()
      copy_assets()
      generate_index()
      generate_query_pages()
    end
  
    def copy_assets(asset_dir=@asset_dir)
      $stderr.puts("Copying assets");
      Dir.new(asset_dir).each() do |file|
        if file != "." and file != ".."
          FileUtils.cp( File.join(asset_dir, file), 
            File.join(@output_dir, file) )
        end
      end
    end
      
    def generate_index()
      $stderr.puts("Generating index.html");
      b = binding
      dir = @dir
      queries = @queries
      template = ERB.new( read_template(:index) )
      html = template.result(b)
      File.open(File.join(@output_dir, "index.html"), "w") do |f|
        f.puts(html)
      end
    end
    
    def generate_query_pages()
      template = ERB.new( read_template(:query) )
      @queries.each do |query|
        $stderr.puts("Generating docs for #{query.path}")
        File.open( File.join(@output_dir, query.output_filename), "w" ) do |f|
          b = binding
          dir = @dir                          
          f.puts( template.result(b) )
        end        
      end     
    end
  
  end
end  