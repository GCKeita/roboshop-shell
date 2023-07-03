component=catalogue
color="\e[33m"
nocolor="\e[0m"

echo -e "${color} Configuring NodeJS Repo ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "${color} Installing NodeJS ${nocolor}"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "${color}Adding application User ${nocolor}"
useradd roboshop &>>/tmp/roboshop.log

echo -e "${color} Creating Application Directory ${nocolor}"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "${color} Downloading Application content ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/$component.zip &>>/tmp/roboshop.log

echo -e "${color} Extracting Application Content ${nocolor}"
cd /app

echo -e "${color} Installing NodeJS Dependencies ${nocolor}"
npm install &>>/tmp/roboshop.log

echo -e "${color} Setup SystemD Service ${nocolor}"
cp /root/roboshop-shell/catalogue.service /etc/systemd/system/$component.service &>>/tmp/roboshop.log

echo -e "${color} Starting $Component service ${nocolor}"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable $component &>>/tmp/roboshop.log
systemctl restart $component &>>/tmp/roboshop.log

echo -e "${color} Copying MongoDB Repo file ${nocolor}"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "${color} Installing MongoDB Client ${nocolor}"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "${color} Loading Schema ${nocolor}"
mongo --host Mmongodb-dev.gckeita-devops.com </app/schema/$component.js &>>/tmp/roboshop.log




