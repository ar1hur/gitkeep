require 'find'

class Gitkeep	
	
	VERSION = '0.2.4'
	attr_accessor :dryrun, :interactive, :__test
	attr_reader :file_count, :error_count

	@@ignores = ['.git']

	def initialize	
		@__test = false
		@dryrun = false
		@interactive = false
		@file_count = 0	
		@error_count = 0
	end

	def create(path)		
		path = "." if path.empty?

		unless File.directory?(path)
			puts red("[error] directory \"#{path}\" not found! abort...")
			return false
		end		

		puts "gitkeep is creating files..."

		Find.find(path) do |p|
		  name = File.basename(p)
		  if File.directory?(p)
		  	if File.readable?(p)
			    if @@ignores.include?(name)
			      Find.prune
			  	else		  		
						if Dir.entries(p).size == 2
							save(p)				
						end
					end
				else
					puts red("[error] could not READ in #{p}/ -> check permissions")
					@error_count += 1
				end					
		  end 		   	   
		end

		puts "finished. #{@file_count} file(s) created!"
		puts red("#{@error_count} error(s)...") if @error_count > 0
		true if @error_count == 0
	end

	def search(path)
		files = []

		Find.find(path) do |p|
		  name = File.basename(p)
			if @@ignores.include?(name)
		    Find.prune
		  else		  
		  	files << p if name == '.gitkeep'
			end	   	   
		end

		add_to_index(files)
	end

	def add_to_index(files)
		puts "adding files to git index..."
		puts files
		files = files.join(' ') if files.kind_of?(Array)
		`git add -f #{files}`
		puts green("files were added!") 
		puts `git status`
	end

	protected if @__test == false

		def save(path)
			gitkeep = "#{path}/.gitkeep"

			unless File.writable?(path)
				puts red("[error] could not WRITE in #{path}/ -> check permissions")
				@error_count += 1
				return false
			end
			
			return true if File.exists?(gitkeep)
			
			if @interactive
				puts "create #{gitkeep} ? [Yn]"
				a = $stdin.gets # read from stdin to avoid collision with params ARGV
				return false unless a == "\n" || a.downcase == "y\n"
			end

			@file_count += 1

			unless @dryrun								
				f = File.new(gitkeep, "w+")
				f.close			
				puts green("created #{gitkeep}")  	    
				true
			else
				puts blue("[dryrun] created #{gitkeep}")
				nil
			end				
		end

	private if @__test == false

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