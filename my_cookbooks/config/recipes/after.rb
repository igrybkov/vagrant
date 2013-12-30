# Install php5-mongo extension
package 'php5-mongo' do
  action :install
end

# Install XDebug
package 'php5-xdebug' do
  action :install
end

# Phing
channel = "pear.phing.info"
execute "pear channel-discover #{channel}" do
  not_if "pear list-channels | grep #{channel}"
end
execute "pear install --alldeps phing/phing" do
  not_if "pear list -c phing | grep '^phing '"
end

# PHPCodeSniffer
execute "pear install --alldeps PHP_CodeSniffer" do
  not_if "pear list -c pear | grep '^PHP_CodeSniffer '"
end
# PHPCodeSniffer Symfony2 Coding Standard
git "/usr/share/php/PHP/CodeSniffer/Standards/Symfony2" do
   repository "https://github.com/opensky/Symfony2-coding-standard.git"
   action :sync
end
bash "Set Symfony2 as default coding standard" do
  code "sudo phpcs --config-set default_standard Symfony2"
  # not_if "ps ax | grep -v grep | grep mailcatcher";
end

package "php5-xsl" do
  action :install
end

package "php5-intl" do
  action :install
end

package "graphviz" do
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

execute 'npm install -g bower less' do
  user 'root'
end

# Install ruby gems
%w{ mailcatcher }.each do |a_gem|
  gem_package a_gem
end
# Setup MailCatcher
bash "run mailcatcher" do
  code "sudo mailcatcher --http-ip 0.0.0.0 --smtp-port 1025"
  not_if "ps ax | grep -v grep | grep mailcatcher";
end
execute 'npm install -g bower --skip-installed' do
  user 'root'
  not_if "which bower >/dev/null"
end

bash "install git-flow-avh" do
  code "wget --no-check-certificate -q  https://raw.github.com/petervanderdoes/gitflow/develop/contrib/gitflow-installer.sh && bash gitflow-installer.sh install stable; rm gitflow-installer.sh"
end

template node['php']['conf_dir']+"/php.ini" do
    cookbook 'php'
    source 'php.ini.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(:directives => node['php']['directives'])
    notifies :restart, 'service[apache2]'
  end

template node['php']['ext_conf_dir']+"/mailcatcher.ini" do
  source "mailcatcher.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end


node['php']['conf_symlinks'].each do |path|
  configs = [
    'php.ini'
  ]
  extensions = [
    'mailcatcher.ini'
  ]

  configs.each do |configFile|
    linkSource = node['php']['conf_dir']+"/"+configFile
    linkDestination = "#{path}/#{configFile}"

    link linkDestination do
      to linkSource
      not_if { linkSource === linkDestination }
      # not_if { File.exist?(linkDestination) }
    end
  end

  extensions.each do |extensionConfigFile|
    linkSource = node['php']['ext_conf_dir']+"/"+extensionConfigFile
    linkDestination = "#{path}/conf.d/#{extensionConfigFile}"

    link linkDestination do
      to linkSource
      not_if { File.exist?(linkDestination) }
    end
  end
  # template "#{path}/php.ini" do
  #   cookbook 'php'
  #   source 'php.ini.erb'
  #   owner 'root'
  #   group 'root'
  #   mode '0644'
  #   variables(:directives => node['php']['directives'])
  #   notifies :restart, 'service[apache2]'
  # end
  # template "#{path}/conf.d/mailcatcher.ini" do
  #   source "mailcatcher.ini.erb"
  #   owner "root"
  #   group "root"
  #   mode "0644"
  #   action :create
  #   notifies :restart, resources("service[apache2]"), :delayed
  # end

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