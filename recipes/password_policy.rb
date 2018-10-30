#
# Cookbook:: .
# Recipe:: password_policy
#
# Copyright:: 2018, The Authors, All Rights Reserved.
template '/etc/login.defs' do
  source 'login.defs.erb'
  owner 'root'
  group 'root'
  mode '0655'
end
