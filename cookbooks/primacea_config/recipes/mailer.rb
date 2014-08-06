node["applications"].each do |app_name, data|

	if ['app master','app'].include? node[:instance_role]
		
		credentials = Chef::EncryptedDataBagItem.load "secrets", app_name

		template "/data/#{app_name}/shared/config/mailer.json" do
			source "mailer.json.erb"
			owner node[:owner_name]
			group node[:owner_name]
			mode "0644"
			variables({
				:mail_service => 	credentials['mailer']['email']['service'],
				:mail_username =>	credentials['mailer']['email']['auth']['user'],
				:mail_password =>	credentials['mailer']['email']['auth']['pass'],
				:mail_reply_to =>	credentials['mailer']['replyTo']	
			})
		end
	end
end


