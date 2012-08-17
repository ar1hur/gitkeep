class Gitkeep	

	attr_accessor :dryrun	

	def initialize	
		@dryrun = false
		@filecount = 0			
	end

	def create(path)		
		path = "." if path.empty?

		unless File.directory?(path)
			puts "error: directory \"#{path}\" not found! abort..."
			return false
		end		

		puts "creating files..."

		ignores = ['.git']

		Find.find(path) do |p|
		  name = File.basename(p)
		  if File.directory?(p)
		    if ignores.include?(name)
		      Find.prune
		  	else		  		
					if Dir.entries(p).size == 2
						@filecount += 1
						createFile(p)				
					end
				end					
		  end	   		   	   
		end

		puts "finished. #{@filecount} file(s) created!"
	end

	protected

		def createFile(path)
			gitkeep = "#{path}/.gitkeep"
			unless File.exists?(gitkeep)
				unless @dryrun								
					f = File.new(gitkeep, "w+")		
					f.close			
					puts green("created #{gitkeep}") 	    	    
				else
					puts blue("[dryrun] created #{gitkeep}")
				end
			end		
		end

	private

		def colorize(text, color_code)
		  "\e[#{color_code}m#{text}\e[0m"
		end
			
		def green(text)
		  colorize(text, 32)
		end

		def blue(text)
		  colorize(text, 36)
		end
end
