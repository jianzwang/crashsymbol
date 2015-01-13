class Crashlog < ActiveRecord::Base
	validates  :name, :status,presence: true
end
