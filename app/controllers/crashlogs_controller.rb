
class CrashlogsController < ApplicationController
	protect_from_forgery :except => :create 

	def new
		@crashlog = Crashlog.new()
	end


	def create
		
		uploaded_io = params[:crashlog][:log]

		batch_id = SecureRandom.uuid().gsub('-','') 

		path = Rails.root.join('public', 'uploads', batch_id)
		FileUtils.mkdir_p path

		file_name = batch_id << '.crash'
		
		File.open(Rails.root.join(path, file_name), 'wb') do |file|
			file.write(uploaded_io.read)
		end
		crashlog = Crashlog.new()
		crashlog.name = batch_id
		crashlog.status = 1
		respond_to do |format|
			if crashlog.save!
				format.html do
					redirect_to '/'
				end
				format.json { render json:@user,status: :created}
			else
				format.html do
					redirect_to '/'
				end
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end
end
