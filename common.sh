color="\e[35m"
nocolor="\e[0m"
log_file=/tmp/roboshop.log
app_path="/app"
user_id=$(id -u)
if [ $user_id -ne 0]; then
  echo Script should be running with sudo
  exit 1
fi

stat_check() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    exit 1
  fi
}

app_presetup() {
    echo -e "${color} Adding application User ${nocolor}"
    id roboshop &>>$log_file
    if [ $? -eq 1 ]; then
      useradd roboshop &>>$log_file
    fi
    stat_check $?

    echo -e "${color} Creating Application Directory ${nocolor}"
    rm -rf ${app_path} &>>$log_file
    mkdir ${app_path}
    stat_check $?

    echo -e "${color} Downloading Application content ${nocolor}"
    curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
    stat_check $?

    echo -e "${color} Extracting Application Content ${nocolor}"
    cd ${app_path}
    unzip /tmp/$component.zip &>>$log_file
    stat_check $?
}

systemd_setup() {
    echo -e "${color} Setup SystemD Service ${nocolor}"
    cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file
    sed -i -e "s/roboshop_app_password/$roboshop_app_password/"  /etc/systemd/system/$component.service
    stat_check $?

    echo -e "${color} Starting $Component service ${nocolor}"
    systemctl daemon-reload &>>$log_file
    systemctl enable $component &>>$log_file
    systemctl restart $component &>>$log_file
    stat_check $?
}

nodejs() {
    echo -e "${color} Configuring NodeJS Repo ${nocolor}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
    stat_check $?

    echo -e "${color} Installing NodeJS ${nocolor}"
    yum install nodejs -y &>>$log_file
    stat_check $?

    app_presetup

    echo -e "${color} Installing NodeJS Dependencies ${nocolor}"
    npm install &>>$log_file
    stat_check $?

    systemd_setup
}

mongo_schema_setup() {
    echo -e "${color} Copying MongoDB Repo file ${nocolor}"
    cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$log_file
    stat_check $?

    echo -e "${color} Installing MongoDB Client ${nocolor}"
    yum install mongodb-org-shell -y &>>$log_file
    stat_check $?

    echo -e "${color} Loading Schema ${nocolor}"
    mongo --host mongodb-dev.gckeita-devops.com ${app_path}/schema/$component.js &>>$log_file
    stat_check $?
}

mysql_schema_setup() {
    echo -e "${color} Installing MySQL Client ${nocolor}"
    yum install mysql -y  &>>$log_file
    stat_check $?

    echo -e "${color} Loading the schema ${nocolor}"
    mysql -h mysql-dev.gckeita-devops.com -uroot -pRoboShop@1 < /app/schema/$component.sql &>>$log_file
    stat_check $?
}

maven() {
    echo -e "${color} Installing Maven ${nocolor}"
    yum install maven -y &>>$log_file
    stat_check $?

    app_presetup

    echo -e "${color} Downloading the Application Dependencies ${nocolor}"
    mvn clean package &>>$log_file
    mv target/$component-1.0.jar $component.jar &>>$log_file
    stat_check $?

    mysql_schema_setup

    systemd_setup

}

python() {
  echo -e "${color} Installing Python 3.6 ${nocolor}"
  yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
  stat_check $?

  app_presetup

  echo -e "${color} downloading Application Dependencies ${nocolor}"
  cd ${app_path}
  pip3.6 install -r requirements.txt &>>/tmp/roboshop.log
  stat_check $?

 systemd_setup
}

golang() {
  echo -e "${color} Installing Golang ${nocolor}"
  yum install golang -y &>>/tmp/roboshop.log
  stat_check $?

  app_presetup

  echo -e "${color} downloading Application Dependencies ${nocolor}"
  cd ${app_path}
  go mod init dispatch &>>/tmp/roboshop.log
  go get &>>/tmp/roboshop.log
  go build &>>/tmp/roboshop.log
  stat_check $?

  sed -i -e "s/roboshop_app_password/$1/" /root/roboshop-shell/$component.service

 systemd_setup
}


