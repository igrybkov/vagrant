# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = 'wheezy64'
  config.vm.box_url = 'https://s3-eu-west-1.amazonaws.com/ffuenf-vagrant-boxes/debian/debian-7.2.0-amd64.box'
  config.ssh.forward_agent = true

  config.vm.network 'private_network', ip: '192.168.255.10'

  config.plugin.deps do
    depend 'vagrant-dns', '0.5.0'
    depend 'vagrant-librarian-chef', '0.1.4'
    depend 'vagrant-vbguest', '0.9.0'
  end

  config.dns.tld = 'dev'
  config.vm.hostname = 'local'

  # Mount shared directories
  Dir['configs/sites/*'].map { |a| File.basename(a, '.*') }.each do |name|
    config.vm.synced_folder '../'+name, '/home/vagrant/'+name, nfs: (RUBY_PLATFORM =~ /linux/ or RUBY_PLATFORM =~ /darwin/)
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1536"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['my_cookbooks', 'cookbooks']
    chef.data_bags_path = 'configs'

    chef.add_recipe 'apt'
    chef.add_recipe 'git'
    chef.add_recipe 'zsh'
    chef.add_recipe 'config::before'
    chef.add_recipe 'config::ohmyzsh'
    #chef.add_recipe 'rvm::vagrant'
    #chef.add_recipe 'rvm::system'
    chef.add_recipe "nodejs::install_from_binary"
    chef.add_recipe "nodejs::npm"
    chef.add_recipe 'tmux'
    chef.add_recipe 'vim'
    chef.add_recipe 'config::vim'

    # Apache2
    chef.add_recipe 'apache2::mod_php5'
    chef.add_recipe 'apache2::default'
    chef.add_recipe 'apache2::mod_expires'
    chef.add_recipe 'apache2::mod_rewrite'
    #chef.add_recipe 'python'
    # PHP
    chef.add_recipe 'php'
    chef.add_recipe 'php::module_curl'
    chef.add_recipe 'php::module_gd'
    chef.add_recipe 'php::module_mysql'
    chef.add_recipe 'php::module_memcache'
    # chef.add_recipe 'php::module_sqlite3'
    chef.add_recipe 'composer'
    #chef.add_recipe 'mongodb::10gen_repo'
    #chef.add_recipe 'mongodb'
    chef.add_recipe 'config::sites'
    chef.add_recipe 'phpmyadmin'
    chef.add_recipe 'phpunit'
    # chef.add_recipe 'mailcatcher'
    chef.add_recipe 'config::after'

    chef.json = {
        :apache => {
            :default_site_enabled => false,
            :dir => '/etc/apache2',
            :log_dir => '/var/log/apache2',
            :error_log => 'error.log',
            :user => 'vagrant',
            :group => 'vagrant',
            :binary => '/usr/sbin/apache2',
            :cache_dir => '/var/cache/apache2',
            :pid_file => '/var/run/apache2.pid',
            :lib_dir => '/usr/lib/apache2',
            :listen_ports => [
                '80'
            ],
            :contact => 'ops@example.com',
            :timeout => '300',
            :keepalive => 'On',
            :keepaliverequests => '100',
            :keepalivetimeout => '5'
        },
        :php => {
            :ext_conf_dir => '/etc/php5/mods-available',
            :directives => {
                'date.timezone' => 'Europe/Kiev'
            },
            :conf_symlinks => [
                '/etc/php5/apache2',
                '/etc/php5/cgi',
                '/etc/php5/cli'
            ]
        },
        :git => {
            :prefix => '/usr/local'
        },
        :mysql => {
            :server_root_password => '',
            :server_repl_password => '',
            :server_debian_password => 'password'
        },
        :vim => {
            :extra_packages => [
                'vim-rails'
            ]
        },
        :composer => {
            :prefix => '/usr/local'
        },
        :mongodb => {
            :package_version => '2.4.0'
        },
        :phpmyadmin => {
            :fpm => false
        }
    }
  end
end
