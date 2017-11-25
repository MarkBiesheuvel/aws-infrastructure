#!/bin/bash

# Upgrade Java
yum install java-1.8.0 -y
yum remove java-1.7.0-openjdk -y

# https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.rpm
rpm --install elasticsearch-6.0.0.rpm
chkconfig --add elasticsearch
