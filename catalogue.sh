component=catalogue

echo -e "\e[33m Configuring NodeJS Repo \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[33m Installing NodeJS \e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33m Adding application User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33m Creating Application Directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[33m Downloading Application content \e[0m"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/$component.zip &>>/tmp/roboshop.log

echo -e "\e[33m Extracting Application Content \e[0m"
cd /app

echo -e "\e[33m Installing NodeJS Dependencies \e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[33m Setup SystemD Service \e[0m"
cp /root/roboshop-shell/catalogue.service /etc/systemd/system/$component.service &>>/tmp/roboshop.log

echo -e "\e[33m Starting Component service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable $component &>>/tmp/roboshop.log
systemctl restart $component &>>/tmp/roboshop.log

echo -e "\e[33m Copying MongoDB Repo file \e[0m"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "\e[33m Installing MongoDB Client \e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[33m Loading Schema \e[0m"
mongo --host Mmongodb-dev.gckeita-devops.com </app/schema/$component.js &>>/tmp/roboshop.log




