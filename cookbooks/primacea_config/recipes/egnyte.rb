node["applications"].each do |app_name, data|

	if ['app master','app'].include? node[:instance_role]
		
		credentials = Chef::EncryptedDataBagItem.load "secrets", app_name

		template "/data/#{app_name}/shared/config/egnyte.json" do
			source "egnyte.json.erb"
			owner node[:owner_name]
			group node[:owner_name]
			mode "0644"
			variables({
				:egnyte_api_key => 	credentials['egnyte']['apiKey']
			})
		end
	end
end


