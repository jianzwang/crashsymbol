class Crashlog < ActiveRecord::Base
	validates  :name,:incidentId,:version,:crashDate,:osVersion,:status,presence: true


	def to_json(options={})
     options[:except] ||= [:id,:created_at,:updated_at]
     super(options)
   end
end
