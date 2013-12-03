apt_repository 'dotdeb-php55' do
  uri 'http://packages.dotdeb.org'
  distribution 'wheezy-php55'
  components ['all']
  key 'http://www.dotdeb.org/dotdeb.gpg'
end

apt_repository 'wheezy-backports' do
  uri 'http://ftp.debian.org/debian'
  distribution 'wheezy-backports'
  components ['main']
end

execute 'apt-get update' do
  user 'root'
end

execute "set zsh as default shell" do
  command "chsh -s $(which zsh) vagrant"
end

#package 'nodejs' do
#  action :install
#end

package 'mysql-server' do
  action :install
end

package 'apache2-mpm-prefork' do
  action :install
end

include_recipe 'build-essential'