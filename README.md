> ![](media/image1.png){width="1.5805555555555555in"
> height="0.7583333333333333in"}

  -- ----------
     Chef Doc
  -- ----------

  -- --------------------- ---------------------
     Document Reference:   None
     Current Version:      1.0
     Version Date:         24/10/2018
     Status                Final
     Author:               Sebastien Chartrand
                           
  -- --------------------- ---------------------

Table of Contents

[1 Document Control 1](#document-control)

[1.1 Document Control/Change History 1](#document-controlchange-history)

[2 Bootstrap / install client 1](#_Toc528587311)

[3 Chef Server user access 1](#chef-server-user-access)

[3.1 List all users 1](#list-all-users)

[3.2 List organization 1](#list-organization)

[3.3 Create user 1](#create-user)

[3.4 Starter kit 1](#starter-kit)

[4 Install Chef Development kit 1](#install-chef-development-kit)

[4.1 Generate cookbook template 1](#generate-cookbook-template)

[4.2 Create an attribute (Variable) 1](#create-an-attribute-variable)

[4.3 Create a template 1](#create-a-template)

[4.4 Generate recipe 1](#generate-recipe)

[5 Kitchen 1](#kitchen)

Document Control
================

Document Control/Change History
-------------------------------

  ------------- ------------ ------------- ---------------------
  **Version**   **Date**     **Comment**   **Editor**
  0.1           2018-06-08   Draft         Sebastien Chartrand
  1.0           2018-08-02   Final         
  ------------- ------------ ------------- ---------------------

Bootstrap / install client
==========================

<https://docs.chef.io/install_chef_air_gap.html>

\# note sudo will want to run with a password, nopass does not seem to
work.

knife bootstrap 10.10.20.55 -x chartrse -P \'2dp00ba3\' \--sudo -N
rtx0l06

knife ssh get's is information from chef server, when the secure bit it
set to on on the node, you need extra attribute, This is in order to
make it harder for the attacker in case you chef server get comprimse.
Ex: you need to specify -a ipaddress

berks upload over knife upload

ohai gather info ip \# cpu and send it to the chef server so it can be
used ex the platform

chartrse\@rtxchwk01 fai\_linux\_patch\]\$ ohai \|grep -i
\'\"platform\":\'

\[2018-10-26T15:59:12-05:00\] INFO: The plugin path
/etc/chef/ohai/plugins does not exist. Skipping\...

\"platform\": \"oracle\",

\[chartrse\@rtxchwk01 fai\_linux\_patch\]\$

knife ssh \'name:rtx0l0\*\' -x chartrse -P \'2dp00ba3\' \'sudo
chef-client\' -a ipaddress

Chef Server user access
=======================

List all users
--------------

chef-server-ctl user-list

List organization
-----------------

chef-server-ctl org-list

Create user
-----------

chef-server-ctl user-create chartrse Sebastien Chartrand
sebastien.chatrand\@fujitsu.com \'2dp00ba3\'

Attach to org has an admin

chef-server-ctl org-user-add rtx chartrse --admin

Starter kit
-----------

The Starter is a preconfigure tar balled directory that has your chef
config and preconfigured. You get fetch it at this location

Ex : <https://198.19.50.71/organizations/ddc/getting_started> =
<https://chefserver/organizations/orgname/getting_started>

-   Click on the Administration tab

![](media/image2.png){width="8.07446741032371in"
height="1.961796806649169in"}

-   Then your organization

![](media/image3.png){width="8.249267279090114in"
height="2.03959864391951in"}

Choose Starter kit

![](media/image4.png){width="5.771665573053368in"
height="3.0895384951881013in"}

-   Then Download Starter kit

![](media/image5.png){width="8.567053805774279in"
height="4.097724190726159in"}

Extract the downloaded file with the utility of your likening. It will
extract a chef-repo directory.

\[chartrse\@rtxchwk01 \~\]\$ cd chef-repo/

The hidden .chef directory is were your chef server key and knife config
resides.

\[chartrse\@rtxchwk01 chef-repo\]\$ cat .chef/

chartrse.pem knife.rb syntaxcache/ trusted\_certs/

\[chartrse\@rtxchwk01 chef-repo\]\$ cat .chef/knife.rb

\# See https://docs.getchef.com/config\_rb\_knife.html for more
information on knife configuration options

current\_dir = File.dirname(\_\_FILE\_\_)

log\_level :info

log\_location STDOUT

node\_name \"chartrse\"

client\_key \"\#{current\_dir}/chartrse.pem\"

chef\_server\_url \"https://rtxlchp01.rtxlab.local/organizations/rtx\"

cookbook\_path \[\"\#{current\_dir}/../cookbooks\"\]

\[chartrse\@rtxchwk01 chef-repo\]\$ ls

cookbooks README.md roles

\[chartrse\@rtxchwk01 chef-repo\]\$

Git
===

Add all files to the commit

git add .

Commit and comment

git commit -m \"First commit\"

Add repository has origin in this example we used GitHub

git remote add origin <https://github.com/aink99/chef_doc.git>

Push your change

git push -u origin master

Add only one file commit and push

touch foobar

git add foobar

git commit -m \"test commit foobar\"

git push

Install Chef Development kit
============================

sudo rpm -Uvh
<https://packages.chef.io/files/stable/chefdk/3.3.23/el/7/chefdk-3.3.23-1.el7.x86_64.rpm>

Note there's no best practice you chose multiple cookbook with one
recipe or a cookbook with multiple recipe.

Ex you could create a cookbook per tower ex fai\_linux\_os and put
multiple Linux recipe for some linux os and another one more specific
fai\_linux\_apache

Generate cookbook template
--------------------------

Configure your get settings (Only if you have not done it brefore)

git config \--global user.email \"sebastien.chartrand\@fujitsu.com\"

git config \--global user.name \"Sebastien Chartrand

Create a directory and generate your cookbook

mkdir chef

cd chef

chef generate cookbook fai\_linux\_baseline

Create an attribute (Variable)
------------------------------

This test coobook is for managing the password length in /etc/login.defs

Within your newly created cookbook generate an attribute called password

chef generate attribute password

cd attributes

vi attributes/password.rb

add the following line and save

default\[\'fai\_linux\_baseline\'\]\[\'password\_length\'\] = \'14\'

Create a template
-----------------

Generate a template and copy or redirect the content of /etc/login.defs

chef generate template . login.defs

cat /etc/login.defs \>\> templates/login.defs.erb

modify the PASS\_MIN\_LEN like this so that it uses the attribute

PASS\_MIN\_LEN **\<%=
node\[\'fai\_linux\_baseline\'\]\[\'password\_length\'\] %\>**

Any other change in that template file will be changed on the node.

 Generate recipe
----------------

chef generate recipe . password\_policy

cd recipes/

edit password\_policy.rb

vim password\_policy.rb

add the following to use your template

template \'/etc/login.defs\' do

source \'login.defs.erb\'

owner \'root\'

group \'root\'

mode \'0655\'

end

Has best practice include your new recipes to the default one

Edit default.rb

vi recipes/default.rb

and add your recipe

include\_recipe \'fai\_linux\_baseline::password\_policy\'

Kitchen
=======

Kitchen starts a small chef server (called chef zero )on from your chef
devlopement kit station and , can test the change. Driver can be
hypervirtual-box(with the vagrant driver), docker etc.

In this example , we don't have any cloud based VM a so will used the
dokken driver (Docker image + systemd)

Install the docker and dokken kitchen driver

chef gem install kitchen-docker

chef gem install kitchen-dokken

Edit the yml file

vi .kitchen.yml

add the following

\-\--

driver:

name: dokken

privileged: true \# because Docker and SystemD/Upstart

provisioner:

name: dokken

transport:

name: dokken

verifier:

name: inspec

platforms:

\#- name: ubuntu-18.04

\# driver:

\# image: dokken/ubuntu-18.04

\# pid\_one\_command: /bin/systemd

\# intermediate\_instructions:

\# - RUN /usr/bin/apt-get update

\- name: centos-7

driver:

image: dokken/centos-7

pid\_one\_command: /usr/lib/systemd/systemd

suites:

\- name: default

run\_list:

\- recipe\[fai\_linux\_baseline::default\]

\#- recipe\[test\_cookbook::default\]

Create your docker dokken image

chartrse\@rtxchwk01 fai\_linux\_baseline\]\$ kitchen create

\-\-\-\--\> Starting Kitchen (v1.23.2)

\-\-\-\--\> Creating \<default-centos-7\>\...

Creating kitchen sandbox at
/home/chartrse/.dokken/kitchen\_sandbox/8f42d15416-default-centos-7

Creating verifier sandbox at
/home/chartrse/.dokken/verifier\_sandbox/8f42d15416-default-centos-7

Building work image..

Creating container 8f42d15416-default-centos-7

Finished creating \<default-centos-7\> (0m4.33s).

\-\-\-\--\> Kitchen is finished. (0m8.02s)

Login to your image

\[chartrse\@rtxchwk01 fai\_linux\_baseline\]\$ kitchen login

\[root\@dokken /\]\# logout

Converge (apply) your change (Note if you have not created your kitchen,
converge will create it for you )

\[chartrse\@rtxchwk01 fai\_linux\_baseline\]\$ kitchen converge

\-\-\-\--\> Starting Kitchen (v1.23.2)

\-\-\-\--\> Converging \<default-centos-7\>\...

Creating kitchen sandbox in
/home/chartrse/.dokken/kitchen\_sandbox/8f42d15416-default-centos-7

Preparing dna.json

Resolving cookbook dependencies with Berkshelf 7.0.6\...

Removing non-cookbook files before transfer

Preparing validation.pem

Preparing client.rb

Starting Chef Client, version 14.5.33

Creating a new client identity for default-centos-7 using the validator
key.

resolving cookbooks for run list: \[\"fai\_linux\_baseline::default\"\]

Synchronizing Cookbooks:

\- fai\_linux\_baseline (0.1.0)

Installing Cookbook Gems:

Compiling Cookbooks\...

Converging 1 resources

Recipe: fai\_linux\_baseline::password\_policy

\* template\[/etc/login.defs\] action create (up to date)

Running handlers:

Running handlers complete

Chef Client finished, 0/1 resources updated in 02 seconds

Finished converging \<default-centos-7\> (0m8.70s).

\-\-\-\--\> Kitchen is finished. (0m12.82s)

Test with inspec
----------------

Edit your recipe test

vi test/integration/default/password\_policy\_test.rb

Add the following resource called file. Here are making sure that the
line that starts with PASS\_MIN\_LEN then we use a world card and make
sure line that end with 14

describe file(\'/etc/login.defs\') do

its(\'content\') { should match /\^PASS\_MIN\_LEN.\*14\$/ }

end

You can test your regex on on the following site :
<https://regex101.com/>

Match:

![](media/image6.png){width="11.65366469816273in"
height="2.995949256342957in"}

No match:

![](media/image7.png){width="11.161069553805774in"
height="3.341311242344707in"}

Kitchen test , buildsm converge, test then destroy kitchen ex:

chartrse\@rtxchwk01 fai\_linux\_baseline\]\$ kitchen test

\-\-\-\--\> Starting Kitchen (v1.23.2)

\-\-\-\--\> Cleaning up any prior instances of \<default-centos-7\>

\-\-\-\--\> Destroying \<default-centos-7\>\...

Deleting kitchen sandbox at
/home/chartrse/.dokken/kitchen\_sandbox/8f42d15416-default-centos-7

Deleting verifier sandbox at
/home/chartrse/.dokken/verifier\_sandbox/8f42d15416-default-centos-7

Finished destroying \<default-centos-7\> (0m11.61s).

\-\-\-\--\> Testing \<default-centos-7\>

\-\-\-\--\> Creating \<default-centos-7\>\...

Creating kitchen sandbox at
/home/chartrse/.dokken/kitchen\_sandbox/8f42d15416-default-centos-7

Creating verifier sandbox at
/home/chartrse/.dokken/verifier\_sandbox/8f42d15416-default-centos-7

Building work image..

Creating container 8f42d15416-default-centos-7

Finished creating \<default-centos-7\> (0m3.86s).

\-\-\-\--\> Converging \<default-centos-7\>\...

Creating kitchen sandbox in
/home/chartrse/.dokken/kitchen\_sandbox/8f42d15416-default-centos-7

Preparing dna.json

Resolving cookbook dependencies with Berkshelf 7.0.6\...

Removing non-cookbook files before transfer

Preparing validation.pem

Preparing client.rb

Starting Chef Client, version 14.5.33

Creating a new client identity for default-centos-7 using the validator
key.

resolving cookbooks for run list: \[\"fai\_linux\_baseline::default\"\]

Synchronizing Cookbooks:

\- fai\_linux\_baseline (0.1.0)

Installing Cookbook Gems:

Compiling Cookbooks\...

Converging 1 resources

Recipe: fai\_linux\_baseline::password\_policy

\* template\[/etc/login.defs\] action create

\- update content in file /etc/login.defs from 11fa3a to a3c20f

\-\-- /etc/login.defs 2016-11-04 18:24:33.000000000 +0000

+++ /etc/.chef-login20181029-52-7f51mg.defs 2018-10-29
18:52:35.848648200 +0000

@@ -23,8 +23,8 @@

\# PASS\_WARN\_AGE Number of days warning given before a password
expires.

\#

PASS\_MAX\_DAYS 99999

-PASS\_MIN\_DAYS 0

-PASS\_MIN\_LEN 5

+PASS\_MIN\_DAYS 5

+PASS\_MIN\_LEN 14

PASS\_WARN\_AGE 7

\#

\- change mode from \'0644\' to \'0655\'

Running handlers:

Running handlers complete

Chef Client finished, 1/1 resources updated in 02 seconds

Finished converging \<default-centos-7\> (0m13.54s).

\-\-\-\--\> Setting up \<default-centos-7\>\...

Finished setting up \<default-centos-7\> (0m0.00s).

\-\-\-\--\> Verifying \<default-centos-7\>\...

Loaded tests from
{:path=\>\".data.home.chartrse.chef-repo.cookbooks.fai\_linux\_baseline.test.integration.default\"}

Profile: tests from
{:path=\>\"/data/home/chartrse/chef-repo/cookbooks/fai\_linux\_baseline/test/integration/default\"}
(tests from
{:path=\>\".data.home.chartrse.chef-repo.cookbooks.fai\_linux\_baseline.test.integration.default\"})

Version: (not specified)

Target:
docker://f2391af73f083027c305ced06224641693e2babcb362e5297b1a5ec6aed7be0c

File /etc/login.defs

✔ content should match /\^PASS\_MIN\_LEN.\*14/

Test Summary: 1 successful, 0 failures, 0 skipped

Finished verifying \<default-centos-7\> (0m3.70s).

\-\-\-\--\> Destroying \<default-centos-7\>\...

Deleting kitchen sandbox at
/home/chartrse/.dokken/kitchen\_sandbox/8f42d15416-default-centos-7

Deleting verifier sandbox at
/home/chartrse/.dokken/verifier\_sandbox/8f42d15416-default-centos-7

Finished destroying \<default-centos-7\> (0m10.93s).

Finished testing \<default-centos-7\> (0m43.73s).

\-\-\-\--\> Kitchen is finished. (0m46.66s)

\[chartrse\@rtxchwk01 fai\_linux\_baseline\]\$ kitchen list

Instance Driver Provisioner Verifier Transport Last Action Last Error

default-centos-7 Dokken Dokken Inspec Dokken \<Not Created\> \<None\>

\[chartrse\@rtxchwk01 fai\_linux\_baseline\]\$

 knife
======

knife node list

knife ssh \'name:rtx0l0\*\' -x chartrse -P \'2dp00ba3\' \'sudo
chef-client\' -a ipaddress

knife node show rtx0l06

knife node run\_list add rtxlks01 \'recipe\[fai\_linux\_baseline\]\'

knife node delete rtxlks01.rtxlab.local

bersk upload
