#
# Cookbook:: .
# Recipe:: tomcat8
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apt_update 'update' do
    action :update
end


packages = 'default-jdk'

package 'java' do
    package_name packages
    action :install
end

user 'tomcat' do
    home '/opt/tomcat'
    action :create
end

group 'tomcat' do
    members 'tomcat'
    action :create
end

remote_file '/tmp/apache-tomcat-8.5.5.tar.gz' do
    source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz'
    action :create
end

directory '/opt/tomcat' do
    action :create
end

execute 'untar' do
    command 'tar xzvf /tmp/apache-tomcat-8.5.5.tar.gz -C /opt/tomcat --strip-components=1'
    action :run
    only_if{ ::File.exist?('/opt/tomcat')}
end

bash 'name' do
    code <<-EOH
    chgrp -R tomcat /opt/tomcat
    chmod -R g+r /opt/tomcat/conf
    chmod g+x /opt/tomcat/conf
    chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
    EOH
    action :run
end

cookbook_file '/etc/systemd/system/tomcat.service' do
    source 'tomcat.service'
    action :create
end

execute 'restahvrt' do
    command 'sudo systemctl daemon-reload'
    action :run
end

service 'tomcat' do
    action :restart
end

cookbook_file '/opt/tomcat/conf/tomcat-users.xml' do
    source 'tomcat-users.xml'
    action :create
end

cookbook_file '/opt/tomcat/webapps/manager/META-INF/context.xml' do
    source 'context.xml'
    action :create
end

cookbook_file '/opt/tomcat/webapps/hostmanager/META-INF/context.xml' do
    source 'context.xml'
    action :create
end

service 'tomcat' do
    action :restart
end

