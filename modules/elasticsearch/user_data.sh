#!/bin/bash

# Set home and go there
export HOME=/root
cd ~

# Update IP
# TODO: remove hardcoded allocation id
aws ec2 associate-address --allocation-id eipalloc-4b7c0765 --instance-id `curl http://169.254.169.254/latest/meta-data/instance-id` --region eu-central-1

# Upgrade Java
yum install java-1.8.0 -y
yum remove java-1.7.0-openjdk -y

# Install Elasticsearch
# https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.rpm
rpm --install elasticsearch-6.0.0.rpm
chkconfig --add elasticsearch
service elasticsearch start

# Install git
yum install git -y

# Create virtual env and continue to work there
pip install virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh
echo 'source /usr/local/bin/virtualenvwrapper.sh' | tee -a .bashrc
mkvirtualenv elastic
workon elastic

# Clone project
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
# TODO: remove hardcoded repo url
git clone https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/elastic-car

# Install requirements
cd elastic-car/api
pip install -r requirements.txt

# Install and run webserver
pip install gunicorn
gunicorn -w 4 app:app &
