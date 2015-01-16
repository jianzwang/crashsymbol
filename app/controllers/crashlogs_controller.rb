
class CrashlogsController < ApplicationController
	protect_from_forgery :except => :create 

	def index
   		@crashlogs = Crashlog.all
    	@crashlog = Crashlog.new()
  	end


	def show
		@crashlog = Crashlog.find(params[:id])
	end


	def create
		
		uploaded_io = params[:log]


		stringIO = StringIO.new
		stringIO.write(uploaded_io.read)


		def extract_line(line)
			if  /(^\w.+)\:\s+(.+)/.match(line)
				#puts "#{$1},#{$2}"
				return [$1,$2]
			else
				return ['','']
			end
			
		end

		def extract_from_parentheses(content)
			if /.+\s+\((.+)\)/.match(content)
				return $1
			else
				return ''
			end
		end


		@crashlog = Crashlog.new()

		stringIO.string.each_line do |line| 
			stripped = self.extract_line(line.strip)
			
			case stripped[0].strip
			when 'Incident Identifier' then
				@crashlog.incidentId = stripped[1]
			when 'CrashReporter Key' then
				@crashlog.name = stripped[1]
			when 'Version' then
				@crashlog.version = stripped[1]
				@crashlog.shortVersion = self.extract_from_parentheses(@crashlog.version)
			when 'Date/Time' then
				@crashlog.crashDate = stripped[1]
			when 'OS Version' then
				@crashlog.osVersion = stripped[1]
			else
			end
		end

		@crashlog.name = SecureRandom.uuid().gsub('-','')  if @crashlog.name == nil
		@crashlog.status = 1

		path = Rails.root.join('public', 'uploads', @crashlog.name)
		FileUtils.mkdir_p path
		file_name = @crashlog.name + '.crash'

		File.open(Rails.root.join(path, file_name), 'wb') do |file|
			contents = stringIO.string
			file.write(contents)
			file.flush
		end

	
		respond_to do |format|
			if @crashlog.save!
				format.html { redirect_to :action=>'show',:id => @crashlog}
				format.json { render json:@crashlog }
			else
				format.html do
					redirect_to '/'
				end
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end
end
