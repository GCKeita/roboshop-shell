source common.sh

echo -e "${color}Copying MongoDB Repo file${nocolor}"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}Installing MongoDB Server${nocolor}"
yum install mongodb-org -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}Updating MongoDB Listen Address${nocolor}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat_check $?

echo -e "${color}Starting MongoDB Server${nocolor}"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl start mongod &>>/tmp/roboshop.log
stat_check $?
