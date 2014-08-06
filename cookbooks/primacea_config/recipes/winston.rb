node["applications"].each do |app_name, data|

	if ['app master','app'].include? node[:instance_role]
		
		template "/data/#{app_name}/shared/config/winston.json" do
			source "winston.json.erb"
			owner node[:owner_name]
			group node[:owner_name]
			mode "0644"
			variables({
			})
		end
	end
end


