#
# Cookbook:: .
# Recipe:: shopizer
#
# Copyright:: 2019, The Authors, All Rights Reserved.


package 'maven' do
    action :install
end

git '/opt/' do
    repository 'https://github.com/shopizer-ecommerce/shopizer.git'
    action :checkout
    notifies :run, 'execute[build]', :immediately
end

execute 'build' do
    command 'mvn clean install'
    action :nothing
end

execute 'move' do
    command 'mv /opt/shopizer/sm-shop/root.war /opt/tomcat/webapps/'
    action :run
end

service 'tomcat' do
    action :restart
end
