#
# Cookbook Name:: yum-cleanup
# Recipe:: default
#
# Copyright (C) 2016 RightScale Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'mixlib/shellout'

rm = Mixlib::ShellOut.new("rm -fr /etc/yum.repos.d/ius.repo")
rm.run_command
puts rm.stdout
puts rm.stderr

clean = Mixlib::ShellOut.new("yum clean metadata")
clean.run_command
puts clean.stdout
puts clean.stderr

cache = Mixlib::ShellOut.new("yum -q -y makecache")
cache.run_command
puts cache.stdout
puts cache.stderr

r = ruby_block "yum-cache-reload" do
  block { Chef::Provider::Package::Yum::YumCache.instance.reload }
  action :nothing
end

r.run_action(:create)
