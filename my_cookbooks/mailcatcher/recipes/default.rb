package "libsqlite3-dev"

gem_package "mailcatcher"

template "/etc/init/mailcatcher.conf" do
  source "mailcatcher.upstart.conf.erb"
  mode 0644
  notifies :restart, "service[mailcatcher]", :immediately
end

service "mailcatcher" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action :nothing
end