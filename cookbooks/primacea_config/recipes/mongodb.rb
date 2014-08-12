if ['app_master', 'app', 'solo', 'util'].include?(node[:instance_role])

  node[:applications].each do |app, data|

     mongodb_replica_set_name = node[:utility_instances]
        .select { |instance| instance[:name].match(/^mongodb_repl/) }
        .map { |instance| instance[:name].split("_")[1]
        .sub("repl","") }
        .uniq
        .join
    
      mongodb_hosts = node[:mongo_utility_instances].select { |instance| instance[:name].match(/^mongodb_repl/) }.map { |instance| instance[:hostname] + ":" + node[:mongo_port] }
      mongodb_urls = mongodb_hosts.join(",") ;
      
      Chef::Log.info "mongodb.rb - mongodb_urls = #{mongodb_urls}"
      Chef::Log.info "mongodb.rb - mongodb_replica_set_name = #{mongodb_replica_set_name}"
 
      template "/data/#{app}/shared/config/mongodb.json" do
        source "mongodb.json.erb"
        owner node[:owner_name]
        group node[:owner_name]
        mode 0655
        variables({
          :mongodb_url => "mongodb://#{mongodb_urls}/?replicaSet=#{mongodb_replica_set_name}"
        })

      end
  end
end
