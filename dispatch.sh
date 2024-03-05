echo -e "${color} Installing GoLang ${nocolor}"
dnf install golang -y &>>/tmp/roboshop.log

echo -e "${color} Add application user ${nocolor}"
useradd roboshop &>>/tmp/roboshop.log

echo -e "${color} Make application directory ${nocolor}"
mkdir /app

echo -e "${color} Downloading Application Content ${nocolor}"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log
cd /app

echo -e "${color} Extracting Application Content ${nocolor}"
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log

echo -e "${color} Installing Application Dependencies ${nocolor}"
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log

echo -e "${color} Starting Dispatch Service ${nocolor}"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl restart dispatch &>>/tmp/roboshop.log

