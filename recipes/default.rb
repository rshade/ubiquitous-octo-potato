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

yum_conf=Mixlib::ShellOut.new("sed -i -e 's/centos-release/redhat-release/' /etc/yum.conf")
yum_conf.run_command
puts yum_conf.stdout
puts yum_conf.stderr

rm = Mixlib::ShellOut.new("rm -fr /etc/yum.repos.d/*.repo")
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

katello = Mixlib::ShellOut.new("yum install http://10.141.33.100/pub/katello-ca-consumer-latest.noarch.rpm -y")
katello.run_command
Chef::Log.info katello.stdout
Chef::Log.info katello.stderr

sm1 = Mixlib::ShellOut.new("subscription-manager register --org=\"#{node['yum-cleanup']['org']}\" --activationkey=\"RHEL 6 #{node['yum-cleanup']['key']} Virtual\"")
sm1.run_command
Chef::Log.info sm1.stdout
Chef::Log.info sm1.stderr

sm2 = Mixlib::ShellOut.new("subscription-manager subscribe --auto")
sm2.run_command
Chef::Log.info sm2.stdout
Chef::Log.info sm2.stderr

sm3 = Mixlib::ShellOut.new("subscription-manager repos --enable=rhel-6-server-rh-common-rpms")
sm3.run_command
Chef::Log.info sm3.stdout
Chef::Log.info sm3.stderr

sm4 = Mixlib::ShellOut.new("subscription-manager refresh")
sm4.run_command
Chef::Log.info sm4.stdout
Chef::Log.info sm4.stderr

yca = Mixlib::ShellOut.new("yum clean all")
yca.run_command
Chef::Log.info yca.stdout
Chef::Log.info yca.stderr

yka = Mixlib::ShellOut.new("yum install katello-agent -y")
yka.run_command
Chef::Log.info yka.stdout
Chef::Log.info yka.stderr

kpu = Mixlib::ShellOut.new("katello-package-upload")
kpu.run_command
Chef::Log.info kpu.stdout
Chef::Log.info kpu.stderr

chk = Mixlib::ShellOut.new("chkconfig goferd on")
chk.run_command
Chef::Log.info chk.stdout
Chef::Log.info chk.stderr

srv = Mixlib::ShellOut.new("service goferd start")
srv.run_command
Chef::Log.info srv.stdout
Chef::Log.info srv.stderr


r = ruby_block "yum-cache-reload" do
  block { Chef::Provider::Package::Yum::YumCache.instance.reload }
  action :nothing
end

r.run_action(:create)
