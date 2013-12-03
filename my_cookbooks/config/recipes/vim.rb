bash "install vim (janus-bootstrap)" do
  user "vagrant"
  code "curl -Lo- https://bit.ly/janus-bootstrap | bash"
  environment "HOME" => "/home/vagrant"
  not_if { File.exist?("/home/vagrant/.vimrc") }
end

template "/home/vagrant/.vimrc.after" do
  source "vimrc_after.erb"
  owner "vagrant"
  group "vagrant"
  mode "0644"
end