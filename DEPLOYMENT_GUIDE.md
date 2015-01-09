# Deployment Guide

## Setup RVM and Ruby 2.1.5
```
sudo yum install gcc-c++ patch readline readline-devel zlib zlib-devel
sudo yum install libyaml-devel libffi-devel openssl-devel make wget git
sudo yum install bzip2 autoconf automake libtool bison iconv-devel
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable
wget ftp://mirror.switch.ch/pool/4/mirror/scientificlinux/7rolling/x86_64/os/Packages/libyaml-devel-0.1.4-10.el7.x86_64.rpm
sudo rpm -Uvh libyaml-devel-0.1.4-10.el7.x86_64.rpm
rvm requirements
rvm install 2.1.5
rvm use 2.1.5 --default
```

## Generate ssh key
```
ssh-keygen -t rsa -C "you@email.com"
```

## Install and setup PostgreSQL
```
sudo rpm -Uvh http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-redhat93-9.3-1.noarch.rpm
sudo yum install postgresql93-server postgresql93 postgresql93-contrib 
sudo yum install postgresql93-server 
sudo su - postgres -c /usr/pgsql-9.3/bin/initdb
sudo vi /var/lib/pgsql/9.3/data/postgresql.conf
sudo vi /var/lib/pgsql/9.3/data/pg_hba.conf
sudo systemctl start postgresql-9.3.service
systemctl enable postgresql-9.3.service
sudo systemctl enable postgresql-9.3.service
sudo su postgres -c 'createuser -s -e efd'
```

## Clone repository
```
git clone git@github.com:khanh2907/boden_food_plate.git
```

## Setup Passenger and Nginx
```
gem install passenger 
sudo yum install curl-devel httpd-devel 
passenger-install-nginx-module
# then follow the prompts
```

## Setup Rails
```
cd boden_food_plate
gem install bundler
gem install pg -v '0.17.1' -- -- with-pg-config=/usr/pgsql-9.3/bin/pg_config
bundle install
RAILS_ENV=production rake db:create db:migrate db:seed
rake assets:precompile RAILS_ENV=production
sudo service nginx restart
```
