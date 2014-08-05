#
# Cookbook Name:: node_knows
# Recipe:: default
#
node["applications"].keys do |app_name|
  if ['app_master','app','db_master','db_slave','util'].include? node[:instance_role]
    template "/data/#{app_name}/node_knows.txt" do
      source "node_knows.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode "0644"
      variables({
         :DeployUser => node[:owner_name],
         :EnvName => node[:environment][:name],
         :AppName => app_name,
         :DbName => node[:engineyard][:environment][:apps].find{|d| d[:name] == app_name}[:database_name],
         :AppMasterHostname => node[:engineyard][:environment][:instances].select{|am| am[:role] == 'app_master'}.first[:public_hostname],
         :DbHostname => node['db_host'],
      })
    end
  elsif ['solo'].include? node[:instance_role]
    template "/data/#{app_name}/node_knows.txt" do
      source "node_knows.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode "0644"
      variables({
        :DeployUser => node[:owner_name],
        :EnvName => node[:environment][:name],
        :AppName => app_name,
        :DbName =>  node[:engineyard][:environment][:apps].find{|d| d[:name] == app_name }[:database_name],
        :AppMasterHostname => node[:engineyard][:environment][:instances].select{|am| am[:role] == 'solo'}.first[:public_hostname],
        :DbHostname => node['db_host'],
      })
    end
  end
end