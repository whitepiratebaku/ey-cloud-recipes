if ['app_master', 'app', 'solo', 'util'].include?(node[:instance_role])

	node[:applications].each do |app, data|

		credentials = Chef::EncryptedDataBagItem.load "secrets", app

		template "/data/#{app}/shared/config/egnyte.json" do
			source "egnyte.json.erb"
			owner node[:owner_name]
			group node[:owner_name]
			mode 0655
			variables({
				:egnyte_api_key => 	credentials['egnyte']['apiKey']
			})
		end
	end
end
