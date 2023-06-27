## copy repo
echo -e "\e[33mCopying MongoDB Repo file\e[0m"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "\e[33mInstalling MongoDB Server\e[0m"
yum install mongodb-org -y &>>/tmp/roboshop.log

echo -e "\e[33mUpdating MongoDB Listen Server\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongodb.conf

echo -e "\e[33mStarting MongoDB Server\e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl start mongod &>>/tmp/roboshop.log

