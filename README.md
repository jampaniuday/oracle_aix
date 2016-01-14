Description
===========
This chef cookbook is based off the work originally published
by Ari Riikonen called Oracle chef cookbook version 1.2.2

It installs and configures the Oracle RDBMS, with patches, to the latest
version of 12c for the AIX Operating System. 
The version with 11g R2 has NOT been tested on AIX.

I wish to acknowldege Air Riikonen's great work here in which
made porting to AIX easy to do. 

Features:
* Oracle 12c Release 1 support with AIX 7.1
(Note Customers using the cookbook must have valid licensing
to use Oracle 12c products).


Non-goals:
* Oracle client install is 11g R2 but has not been tested on AIX and
  given the work done on AIX, expect there to be some issues if tried.
* We did not port Oracle 11gr2 Release support to AIX 7.1. It was
  a non-goal.

DiskSpace:
==========
Available Disk space file system:
/oracle         - default base and temp install area: 10 GB
/oracle/oradata - default oracle data directory     : 10 GB
/opt            - chef installation                 :  1 GB
/tmp            - available temp space              : 10 GB

Quickstart (database)
=====================

* Have either an open Source Chef Server or a Hosted Chef account at
  the ready.
* Use AIX 7.1 or later.
* Requires a web server for Oracle source files.  Set up a Web server 
  to serve them over HTTPS unless you're on a secure local network.
* Create a role to override the default attribute values for the URLs
  of Oracle's install files & patches with your own; e.g.:

  ora_12c_aix.rb
  ==========================================================
  name "ora_12c_aix"
  description "Role applied to Oracle 12c AIX test machines."
  
  run_list 'recipe[aix-base-setup]', 'recipe[oracle_aix]',
    'recipe[oracle_aix::logrotate_alert_log]',
    'recipe[oracle_aix::logrotate_listener]',
    'recipe[oracle_aix::createdb]'

  override_attributes :oracle => {
    :rdbms => {
      :dbs_root       => "/opt/oradata",
      :sys_pw         => 'oracle',
      :system_pw      => 'oracle',
      :dbsnmp_pw      => 'oracle',
      :latest_patch => {
        :dirname_12c =>      '20831110',
        :url =>              'http://localhost/CHEF/oracle/p20831110_121020_AIX64-5L.zip'},
      :opatch_update_url =>  'http://localhost/CHEF/oracle/p6880880_121010_AIX64-5L.zip',
      :install_files     => ['http://localhost/CHEF/oracle/V73231-01_1of2.zip',
                             'http://localhost/CHEF/oracle/V73231-01_2of2.zip'],
      :dbbin_version     => '12c',
      },
    :user => {
      :uid => 4000,
      :gid => 4000,
      :edb_use => false,
      :ora_pw  => 'oracle',
      }
    }
  ==========================================================
  
* You need to set up an encrypted data bag item to secure the oracle
  user's password. See Opscode's docs site for details on encrypted
  data bags:
  [encrypted data bag doc](http://docs.opscode.com/chef/essentials_data_bags.html#encrypt-a-data-bag)
  Your encrypted item requires a key named `pw`, whose value is the
  password of the oracle user- you can set that to whatever you want.
  You must set the value of `node[:oracle][:user][:edb]` to the name
  of your data bag, and that of `node[:oracle][:user][:edb_item]` to
  the name of the encrypted item; the defaults are `oracle` and
  `foo`, respectively.

* alternatively, setting :ebs_use to false and setting :ora_pw will
  use the password provided.
      :edb_use => false,
      :ora_pw  => 'oracle',

* Bootstrap the node, telling Chef to create the FOO database on it:

  12c :
    knife bootstrap HOSTNAME -x root -P <rootpassword>
        -N HOSTNAME '-r role[ora_12c_aix]'  
        -j '{oracle:{rdbms:{dbs:{FOO:false}}}}' -y -V

* Go grab a cup of tea, as this is apt to take a fair amount of time
to complete :-)


Requirements
============

## Oracle

See here:

[Oracle's requirements for 12c]
  See edelivery and check the latest patches for the oracle 12c database
  This installtion uses update patch 20831110  DATABASE PATCH SET UPDATE 12.1.0.2.4 

## Chef

This cookbook was successfully tested using Chef-Client 12.5.1, in combo
with the open source Chef Server 12, as well as with Hosted Chef.

then run `chef-server-ctl reconfigure` to reconfigure Chef Server.

## Platforms

*# `AIX 7.1 (power7)`

## Packages

* Access to My Oracle Support to download the 11g R2 install media
  and the patch files.

* Download the 12.1.0.2.4 install files from eDelivery.oracle.com
  My Oracle Support as well as an active CSI.

  12c
  
    Oracle 12c OPatch 12.1.0.1.8       - p6880880_121010_AIX64-5L.zip
    Oracle 12c Patch 12.1.0.2.4        - p20831110_121020_AIX64-5L.zip
    Oracle 12c 12.1.0.2.0 DBMS         - V73231-01_1of2.zip
    Oracle 12c 12.1.0.2.0 DBMS         - V73231-01_2of2.zip
    Oracle 12c 12.1.0.2.0 64bit Client - V73233-01.zip

## Miscellaneous

* Ensure that your FQDN is properly configured (check the output of
  `hostname -f`), else runInstaller will fail.
* At least a basic knowledge of Oracle administration will come in
  handy, in particular if you want to modify attributes' values
  and/or modify the cookbook's code or resources.

* Please check Oracle database specific swap recommendations from:


See Ari's Original README.md called READMEPRE_AIX.md for much
further important information.

License and Authors
===================

* Author for AIX port:: Jubal Kohlmeier <jubal@us.ibm.com>  

Original Authors:
* Author:: Ari Riikonen <ari.riikonen@gmail.com>  
* Author:: Dominique Poulain

Copyright:: 2014, Ari Riikonen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
