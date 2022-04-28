#!/bin/sh
apt update
apt upgrade -y

#echo "INSTALLING node"
#apt install -y nodejs

#echo "INSTALLING npm"
#apt install -y npm

#echo "INSTALLING yarn"
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

#apt update
#apt install yarn -y

echo "INSTALLING mariadb-server" # used to be mariadb-server
apt update
apt install mariadb-server -y

echo "INSTALLING apache2 webserver" # used to be mariadb-server
apt update
apt install apache2 -y

echo "INSTALLING packages to allow apt to use a repository over HTTPS"
apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
echo "INSTALLING docker key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# set up the stable repository
echo "INSTALLING stable repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install docker-ce docker-ce-cli containerd.io -y

git clone https://github.com/leoyulee/PHPCourseManagement.git

cp -r PHPCourseManagement/ /var/www/html/
# pull docker image
# echo "PULLING docker image"
# docker pull leoyulee/PHPCourseManagement:latest

# run docker image
# echo "RUNNING docker image"
# docker run -d -p 3000:3000 --name dseng leoyulee/PHPCourseManagement:latest