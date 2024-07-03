source common.sh

echo -e "${color}\Installing Redis Repos${nocolor}"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log
stat_check $?

echo -e "\${color}Enabling Redis 6 version${nocolor}"
yum module enable redis:remi-6.2 -y &>>/tmp/roboshop.log
stat_check $?

echo -e "\${color}Installing Redis${nocolor}"
yum install redis -y &>>/tmp/roboshop.log
stat_check $?

echo -e "\${color}Updating Redis Listen Address${nocolor}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>/tmp/roboshop.log
stat_check $?

echo -e "\${color}Starting Nginx Service${nocolor}"
systemctl enable redis &>>/tmp/roboshop.log
systemctl start redis &>>/tmp/roboshop.log
stat_check $?