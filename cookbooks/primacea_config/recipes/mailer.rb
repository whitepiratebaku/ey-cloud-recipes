if ['app_master', 'app', 'solo', 'util'].include?(node[:instance_role])

	node[:applications].each do |app, data|

		credentials = Chef::EncryptedDataBagItem.load "secrets", app

		template "/data/#{app}/shared/config/mailer.json" do
			source "mailer.json.erb"
			owner node[:owner_name]
			group node[:owner_name]
			mode 0655
			variables({
				:mail_service => 	credentials['mailer']['email']['service'],
				:mail_username =>	credentials['mailer']['email']['auth']['user'],
				:mail_password =>	credentials['mailer']['email']['auth']['pass'],
				:mail_reply_to =>	credentials['mailer']['replyTo']	
			})
		end
	end
end

