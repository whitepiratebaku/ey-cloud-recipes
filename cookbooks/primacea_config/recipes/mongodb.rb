if node[:utility_instances].empty?
  # no-op here as there are no utility instances, do not pass.
else
  node["applications"].each do |app_name, data|

    if ['app master','app'].include? node[:instance_role]
      mongodb_replica_set_name = node[:utility_instances]
        .select { |instance| instance[:name].match(/^mongodb_repl/) }
        .map { |instance| instance[:name].split("_")[1]
        .sub("repl","") }
        .uniq
        .join

      #Chef::Log.info "app.rb - mongodb_replica_set_name = #{mongodb_replica_set_name}"
    
      mongodb_hosts = node[:mongo_utility_instances].select { |instance| instance[:name].match(/^mongodb_repl/) }.map { |instance| instance[:hostname] + ":" + node[:mongo_port] }
      mongodb_urls = mongodb_hosts.join(",") ;
      #Chef::Log.info "app.rb - mongodb_urls = #{mongodb_urls}"
 
      template "/data/#{app_name}/shared/config/mongodb.json" do
        source "mongodb.json.erb"
        owner node[:owner_name]
        group node[:owner_name]
        mode "0644"
        variables({
          :mongodb_url => "mongodb://#{mongodb_urls}/?replicaSet=#{mongodb_replica_set_name}"
        })

      end
    end
  end
end
