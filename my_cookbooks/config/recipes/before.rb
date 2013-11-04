#apt_repository 'php5' do
#  uri 'http://ppa.launchpad.net/chris-lea/php5.5/ubuntu'
#  distribution node['lsb']['codename']
#  components ['main']
#  keyserver 'keyserver.ubuntu.com'
#  key 'E5267A6C'
#end

apt_repository 'dotdeb-php55' do
  uri 'http://packages.dotdeb.org'
  distribution 'wheezy-php55'
  components ['all']
  key 'http://www.dotdeb.org/dotdeb.gpg'
end

execute 'apt-get update' do
  user 'root'
end

package 'mysql-server' do
  action :install
end

package 'apache2-mpm-prefork' do
  action :install
end

include_recipe 'build-essential'