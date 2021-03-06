#
# Cookbook Name:: redis
# Recipe:: default
#
# Author:: Jamie Winsor (<jwinsor@riotgames.com>)
# Copyright 2011, Riot Games
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "redis"

user node[:redis][:user] do
  home node[:redis][:data_dir]
  system true
end

directory node[:redis][:conf_dir] do
  owner "root"
  group "root"
  mode "0755"
end

directory node[:redis][:db_dir] do
  owner node[:redis][:user]
  mode "0750"
end

service "redis" do
  supports :reload => false, :restart => true, :start => true, :stop => true
  action [ :enable, :start ]
end

template "#{node[:redis][:conf_dir]}/redis.conf" do
  source "redis.conf.erb"
  mode "0644"
  notifies :restart, resources(:service => "redis")
end
