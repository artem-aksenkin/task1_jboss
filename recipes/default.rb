#
# Cookbook:: task1_jboss
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#node.normal['jboss']['dir'] = '/opt/wildfly'

package 'unzip' do
  action :install
end


bash 'extract_module' do
  code <<-EOH
    mkdir -p /opt/wildfly
    cd /tmp/chef-pkgs
    unzip /tmp/chef-pkgs/wildfly-10.1.0.Final.zip
    mv wildfly-10.1.0.Final/* /opt/wildfly
    EOH
  not_if { ::Dir.exist?("/opt/wildfly/bin") }
end

template '/etc/systemd/system/jboss.service' do
  source 'jboss.service.erb'
  mode '0744'
end

service 'jboss' do
  action [:enable, :start]
end

remote_file '/opt/wildfly/standalone/deployments/HelloWorldWebApp.zip' do
  source 'http://centerkey.com/jboss/HelloWorldWebApp.zip'
  action :create
end

bash 'deploy_war' do
  code <<-EOH
    cd /opt/wildfly/standalone/deployments/
    unzip HelloWorldWebApp.zip
    mv HellowWorld/helloworld.war .
    rm -rf HellowWorld
    EOH
  not_if { ::File.exist?("/opt/wildfly/standalone/deployments/helloworld.war") }
  notifies :restart, 'service[jboss]', :immediately
end