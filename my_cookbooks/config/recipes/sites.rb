# Initialize sites data bag
sites = []
begin
  sites = data_bag("sites")
rescue
  puts "Sites data bag is empty"
end

sites.each do |site|
  opts = data_bag_item('sites', site)

  web_app opts['id'] do
    cookbook 'apache2'
    server_name opts['server_name']
    server_aliases opts['server_aliases']
    allow_override opts['allow_override']
    docroot (opts.has_key?('docroot') ? opts['docroot'] : '/home/vagrant/'+opts['id']+'/web')
    notifies :restart, 'service[apache2]'
  end

end

# PhpMyAdmin
web_app 'pma' do
    cookbook 'apache2'
    server_name 'pma.local.dev'
    server_aliases ['pma.dev','phpmyadmin.local.dev', 'phpmyadmin.dev']
    allow_override 'All'
    docroot '/opt/phpmyadmin/'
    notifies :restart, 'service[apache2]'
end