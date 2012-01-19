#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

if platform?("redhat", "centos", "fedora")

template "/etc/yum.repos.d/epel.repo" do
        source "epel.repo.erb"
#	not_if "test -f /etc/yum.repos.d/epel.repo"
	end
end


package "autossh" do
	action [:install]
end

template "/usr/local/sbin/tunnels.sh" do
	mode "755"
	source "tunnels.sh.erb"

end


node['tunnels'].each do |p,r|
execute "tunnels.sh" do
 command "tunnels.sh add #{r}"
 action :run
 end
end

