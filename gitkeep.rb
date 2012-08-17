#!/usr/bin/env ruby

# gitkeep
# create .gitkeep files in all empty directories in your project
# https://github.com/ar1hur/gitkeep.git
#
# MIT License Copyright (c) 2012 Arthur Zielinski
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


require 'find'

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

		puts "finished. #{@filecount} files created!"
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

gitkeep = Gitkeep.new
ARGV.sort.each do |arg|				
	gitkeep.dryrun = true if arg == "-d"
	gitkeep.create(arg) unless arg =~ /^-+/
end