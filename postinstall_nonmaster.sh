#! /bin/bash
sudo yum-config-manager --add-repo https://release.memsql.com/production/rpm/x86_64/repodata/memsql.repo 
sudo yum install -y memsql-client memsql-toolbox memsql-studio
