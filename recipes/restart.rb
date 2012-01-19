#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

execute "tunnels.sh" do
  command "tunnels.sh restart"
  action :run
end
