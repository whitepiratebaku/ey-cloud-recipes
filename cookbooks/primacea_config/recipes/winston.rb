if ['app_master', 'app', 'solo', 'util'].include?(node[:instance_role])

	node[:applications].each do |app, data|

		credentials = Chef::EncryptedDataBagItem.load "secrets", app

		logPath = "/var/log/#{app}.log"

		template "/data/#{app}/shared/config/winston.json" do
			source "winston.json.erb"
			owner node[:owner_name]
			group node[:owner_name]
			mode 0655
			variables({
				:subdomain => 	credentials['winston']['loggly']['subdomain'],
				:username =>	credentials['winston']['loggly']['auth']['username'],
				:password =>	credentials['winston']['loggly']['auth']['password'],
				:inputToken =>	credentials['winston']['loggly']['inputToken'],	
				:logPath => 	logPath
			})
		end

		file "/var/log/#{app}.log" do
			owner node[:owner_name]
			group node[:owner_name]
			mode "0666"
			action :create
		end
	end
end
