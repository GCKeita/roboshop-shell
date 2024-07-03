source common.sh

echo -e "${color} Disabling MySQL Default version ${nocolor}"
yum module disable mysql -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Copying MySQL Repo File ${nocolor}"
cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Installing MySQL Community Server ${nocolor}"
yum install mysql-community-server -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Starting MySQL Service ${nocolor}"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Setup Password ${nocolor}"
mysql_secure_installation --set-root-pass $1 &>>/tmp/roboshop.log
stat_check $?