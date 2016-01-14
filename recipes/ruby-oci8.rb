#
# Cookbook Name:: oracle_aix
# Recipe:: ruby-oci8
# Author:: Julian C. Dunn (<jdunn@getchef.com>)
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

ENV['ORACLE_HOME'] = node[:oracle][:rdbms][:ora_home]

gem_package 'ruby-oci8' do
  gem_binary('/opt/chef/embedded/bin/gem') if File.exists?('/opt/chef/embedded/bin/gem')
  action :install
end
