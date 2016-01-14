#
# Cookbook Name:: oracle_aix
# Recipe:: kernel_params
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
#
## Configure kernel parameters for Oracle RDBMS.
#

case node["platform"]
when "redhat", "centos", "fedora"
  bash 'sysctl_reload' do
    code 'source /etc/init.d/functions && apply_sysctl'
    action :nothing
  end
  
  directory '/etc/sysctl.d' do
    mode '0755'
  end
  
  cookbook_file '/etc/sysctl.d/ora_params' do
    mode '0644'
    notifies :run, 'bash[sysctl_reload]', :immediately
  end
when "aix"
  log '****************************************************************************'
  log '*                                                                          *'
  log '*                        Oracle Recipe: kernel_params                      *'
  log '*   Setting Max Proccess per User, and enabling IO Completion Ports ...    *'
  log '*                                                                          *'
  log '****************************************************************************'

  # theres no limits.d directory on AIX
  execute "change_maxuproc_on_AIX" do
    command "chdev -l sys0 -a maxuproc=16384"
    not_if  "lsattr -D -l sys0 -a maxuproc | perl -lane '($f1,$val,$rest)=split; exit($val>=16384) > /dev/null 2>&1'"
  end

  execute "change_iocp_on_AIX" do
    command "chdev -l iocp0 -P -a autoconfig=available"
    not_if "lsdev -Cc iocp | grep Available > /dev/null 2>&1"
  end
end
