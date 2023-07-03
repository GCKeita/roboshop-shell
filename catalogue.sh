source common.sh
component=catalogue

nodejs

echo -e "${color} Copying MongoDB Repo file ${nocolor}"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$log_file

echo -e "${color} Installing MongoDB Client ${nocolor}"
yum install mongodb-org-shell -y &>>$log_file

echo -e "${color} Loading Schema ${nocolor}"
mongo --host Mmongodb-dev.gckeita-devops.com ${app_path}/schema/$component.js &>>$log_file




