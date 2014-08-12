if ['app_master', 'app', 'solo', 'util'].include?(node[:instance_role])

	node[:applications].each do |app, data|

		credentials = Chef::EncryptedDataBagItem.load "secrets", app

		template "/data/#{app}/shared/config/pdfcrowd.json" do
			source "pdfcrowd.json.erb"
			owner node[:owner_name]
			group node[:owner_name]
			mode 0655
			variables({
				:pdfcrowd_username => 	credentials['pdfCrowd']['username'],
				:pdfcrowd_password => 	credentials['pdfCrowd']['password']
			})
		end
	end
end
