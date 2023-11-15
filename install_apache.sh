#!/bin/bash
#updating software package
sudo yum update -y
#installing apache
sudo yum install -y httpd
#enabling httpd service
sudo systemctl start httpd
#enabling httpd service at boot time
sudo systemctl enable httpd
#display web page
echo "<h1>Dicha Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html