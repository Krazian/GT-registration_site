# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 

User.all.each do |user|
	user.mobile_device.split(",").each do |device|
		case device.strip
		when "iphone"
			user.update(:iphone => true)
		when "android"
			user.update(:android => true)
		when "blackberry"
			user.update(:blackberry => true)
		when "ipad"
			user.update(:ipad => true)
		when "tablet"
			user.update(:tablet => true)
		else #other
			user.update(:other => true)
		end
	end
end