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

		puts "gitkeep is creating files..."

		ignores = ['.git']

		Find.find(path) do |p|
		  name = File.basename(p)
		  if File.directory?(p)
		  	if File.readable?(p)
			    if ignores.include?(name)
			      Find.prune
			  	else		  		
						if Dir.entries(p).size == 2
							createFile(p)				
						end
					end
				else
					puts red("[error] could not READ in #{p}/ -> check permissions")
				end					
		  end	   		   	   
		end

		puts "finished. #{@filecount} file(s) created!"
	end

	protected

		def createFile(path)
			gitkeep = "#{path}/.gitkeep"

			unless File.writable?(path)
				puts red("[error] could not WRITE in #{path}/ -> check permissions")
				return false
			end
			
			unless File.exists?(gitkeep)
				unless @dryrun								
					f = File.new(gitkeep, "w+")		
					f.close			
					puts green("created #{gitkeep}") 	    	    
				else
					puts blue("[dryrun] created #{gitkeep}")
				end
			end

			@filecount += 1

		end

	private

		def colorize(text, color_code)
		  "\e[#{color_code}m#{text}\e[0m"
		end
			
		def green(text)
		  colorize(text, 32)
		end

		def red(text)
		  colorize(text, 31)
		end		

		def blue(text)
		  colorize(text, 36)
		end
end
