require 'spec_helper'
require 'gitkeep'

describe "Gitkeep" do

	before do
		@gitkeep = Gitkeep.new
		@gitkeep.__test = true

		unless Dir.exists?('./testdir')
			Dir.mkdir('./testdir')
			Dir.mkdir('./testdir/not_writeable', 0555)
			Dir.mkdir('./testdir/not_readable', 0333)
			Dir.mkdir('./testdir/dirnot_readable_and_not_writeable', 0000)
			Dir.mkdir('./testdir/valid')
		end

		@gitkeep_file = './testdir/valid/.gitkeep'

		File.delete(@gitkeep_file) if File.exists?(@gitkeep_file)

		@error_count = @gitkeep.error_count
		@file_count  = @gitkeep.file_count
	end

	context "before execute any tests" do

		it "should be set in test mode" do
			@gitkeep.__test.should be_true
		end

		it "should be not exists a .gitkeepfile in ./test/valid directory" do
			File.exists?(@gitkeep_file).should be_false
		end

		it "should initialize all counter with zero" do
			@error_count.should be 0
			@file_count.should be 0
		end

	end

	context "without options" do
		
		it "should create a .gitkeep file in an empty directory and increment a counter" do
			File.delete(@gitkeep_file) if File.exists?(@gitkeep_file)

			@gitkeep.save('./testdir/valid').should be_true
			File.exists?(@gitkeep_file).should be_true
			@gitkeep.file_count.should be > @file_count
		end

	end

	context "with option" do

		context "dryrun" do
			it "should be not create .gitkeep files" do
				@gitkeep.dryrun = true		
				@gitkeep.save('./testdir/valid').should be_nil
				File.exists?(@gitkeep_file).should be_false
				@gitkeep.file_count.should be > @file_count
			end
		end

		context "interactive" do

			before do
				@gitkeep.interactive = true	
			end

			it "should create a file when i want it" do
				@gitkeep.should_receive(:puts).with(/create/)
				$stdin.stub!(:gets) { "\n" }
				@gitkeep.save('./testdir/valid')
			end
		end

	end

	context "lack of permissions" do

		it "should display an error if the directory not exists" do
			@gitkeep.should_receive(:puts).with(/\[error\]/)
			@gitkeep.create('./some/not/existin/folder').should be_false
		end  

		it "should throw an error and increment a counter when a directory is not accessible" do
			@gitkeep.should_receive(:puts).with('gitkeep is creating files...').once
			@gitkeep.should_receive(:puts).with(/\[error\] .+ READ/)
			@gitkeep.should_receive(:puts).with(/finished/)
			@gitkeep.should_receive(:puts).with(/error\(s\)/)
			@gitkeep.create('./testdir/not_readable').should_not be_true
			@gitkeep.error_count.should be > @error_count
		end

		it "should throw an error and count it when a file could not be written successfully" do
			@gitkeep.should_receive(:puts).with(/\[error\] .+ WRITE/)
			@gitkeep.save('./testdir/not_writeable').should be_false
			@gitkeep.error_count.should be > @error_count
		end

	end
end
