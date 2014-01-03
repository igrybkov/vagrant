# Vagrant
## Description
Vagrant configuration for web development.

## Currently include:
* Apache 2.2
* PHP 5.5
* XDebug
* MySQL
* tmux
* vim
* git
* composer

## Installation
* Install [VirtualBox](https://www.virtualbox.org/)
* Install [Vagrant](http://www.vagrantup.com/)
* Install plugin dependencies

````sh
sudo apt-get install build-essential g++
vagrant plugin install vagrant-plugin-bundler
````
* Clone this repo:
    ````git clone git@github.com:igrybkov/vagrant.git````
* vagrant up

## Usage
* Create file for new project in ````configs/sites/````. Use test.json as template

## Tips
* For faster start use ````vagrant up --no-provision````
 
## ToDo:
* ZSH
* Ruby (RVM)
* MailCatcher
* MongoDB
* ElasticSearch
* Python
* NodeJS
* Sphinx
