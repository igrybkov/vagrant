# Install php5-mongo extension
package 'php5-mongo' do
  action :install
end

# Install XDebug
package 'php5-xdebug' do
  action :install
end

xdebug = data_bag_item('php', 'xdebug')
template node['php']['ext_conf_dir']+'/xdebug.ini' do
  source 'xdebug.ini.erb'
  owner 'root'
  group 'root'
  variables(
      :params => xdebug
  )
  notifies :restart, 'service[apache2]'
  mode 0644
end

%w(/etc/php5/apache2 /etc/php5/cgi).each do |path|
  template "#{path}/php.ini" do
    cookbook 'php'
    source 'php.ini.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(:directives => node['php']['directives'])
    notifies :restart, 'service[apache2]'
  end
end

#if node[:phpmyadmin] == true
#  remote_file '/tmp/phpmyadmin.tar.gz' do
#    source 'http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.5.3/phpMyAdmin-3.5.3-all-languages.tar.gz?r=&ts=#{Time.now.to_i}&use_mirror=autoselect'
#    owner node[:nginx][:user]
#    group node[:nginx][:user]
#    mode '0644'
#  end
#
#  execute 'rm -rf /var/www/phpmyadmin/*'
#  execute 'tar -C /tmp -zxvf /tmp/phpmyadmin.tar.gz'
#  execute 'mv /tmp/phpMyAdmin-*/* /var/www/phpmyadmin'
#end