user_id = 'vagrant'
git "/home/#{user_id}/.oh-my-zsh" do
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  user user_id
  group user_id
  action :checkout
  not_if "test -d /home/#{user_id}/.oh-my-zsh"
end

config = data_bag_item( "shell", 'ohmyzsh' )
theme = config["theme"]

template "/home/#{user_id}/.zshrc" do
  source "zshrc.erb"
  owner user_id
  group user_id
  variables(
    :theme => ( theme || node[:ohmyzsh][:theme] ),
    :plugins => config["plugins"]
  )
  # action :create_if_missing
end