echo -e "\e[33m Disabling MySQL Default version \e[0m"
yum module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[33m Copying MySQL Repo File \e[0m"
cp /root/roboshop-shell/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[33m Installing MySQL Community Server \e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[33m Starting MySQL Service \e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

echo -e "\e[33m Setup Password \e[0m"
mysql_secure_installation --set-root-pass $1 &>>/tmp/roboshop.log


