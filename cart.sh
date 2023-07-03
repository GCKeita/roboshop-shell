source common.sh
component=cart

echo -e "${color} Configuring NodeJS Repo ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

echo -e "${color} Installing NodeJS ${nocolor}"
yum install nodejs -y &>>$log_file

echo -e "${color} Adding application User ${nocolor}"
useradd roboshop &>>$log_file

echo -e "${color} Creating Application Directory ${nocolor}"
rm -rf ${app_path} &>>$log_file
mkdir ${app_path}

echo -e "${color} Downloading Application content ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
cd ${app_path}
unzip /tmp/$component.zip &>>$log_file

echo -e "${color} Extracting Application Content ${nocolor}"
cd ${app_path}

echo -e "${color} Installing NodeJS Dependencies ${nocolor}"
npm install &>>$log_file

echo -e "${color} Setup SystemD Service ${nocolor}"
cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file

echo -e "${color} Starting $component service ${nocolor}"
systemctl daemon-reload &>>$log_file
systemctl enable $component &>>$log_file
systemctl restart $component &>>$log_file



