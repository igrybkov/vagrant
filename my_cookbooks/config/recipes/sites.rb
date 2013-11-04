data_bag('sites').each do |site|
  opts = data_bag_item('sites', site)

  web_app opts['id'] do
    cookbook 'apache2'
    server_name opts['server_name']
    server_aliases opts['server_aliases']
    allow_override opts['allow_override']
    docroot '/home/vagrant/'+opts['id']+'/web'
    notifies :restart, 'service[apache2]'
  end

end