color="\e[35m"
nocolor="\e[0m"
log_file=/tmp/roboshop.log
app_path="/app"
app_presetup() {
    echo -e "${color} Adding application User ${nocolor}"
    useradd roboshop &>>$log_file
    echo $?

    echo -e "${color} Creating Application Directory ${nocolor}"
    rm -rf ${app_path} &>>$log_file
    mkdir ${app_path}
    echo  $?

    echo -e "${color} Downloading Application content ${nocolor}"
    curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
    echo $?

    echo -e "${color} Extracting Application Content ${nocolor}"
    cd ${app_path}
    unzip /tmp/$component.zip &>>$log_file
    echo $?
}

systemd_setup() {
    echo -e "${color} Setup SystemD Service ${nocolor}"
    cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file
    echo $?

    echo -e "${color} Starting $Component service ${nocolor}"
    systemctl daemon-reload &>>$log_file
    systemctl enable $component &>>$log_file
    systemctl restart $component &>>$log_file
    echo $?
}

nodejs() {
    echo -e "${color} Configuring NodeJS Repo ${nocolor}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

    echo -e "${color} Installing NodeJS ${nocolor}"
    yum install nodejs -y &>>$log_file

    app_presetup

    echo -e "${color} Installing NodeJS Dependencies ${nocolor}"
    npm install &>>$log_file

    systemd_setup
}

mongo_schema_setup() {
    echo -e "${color} Copying MongoDB Repo file ${nocolor}"
    cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$log_file

    echo -e "${color} Installing MongoDB Client ${nocolor}"
    yum install mongodb-org-shell -y &>>$log_file

    echo -e "${color} Loading Schema ${nocolor}"
    mongo --host mongodb-dev.gckeita-devops.com ${app_path}/schema/$component.js &>>$log_file
}

mysql_schema_setup() {
    echo -e "${color} Installing MySQL Client ${nocolor}"
    yum install mysql -y  &>>$log_file

    echo -e "${color} Loading the schema ${nocolor}"
    mysql -h mysql-dev.gckeita-devops.com -uroot -pRoboShop@1 < /app/schema/$component.sql &>>$log_file
}

maven() {
    echo -e "${color} Installing Maven ${nocolor}"
    yum install maven -y &>>$log_file

    app_presetup

    echo -e "${color} Downloading the Application Dependencies ${nocolor}"
    mvn clean package &>>$log_file
    mv target/$component-1.0.jar $component.jar &>>$log_file

    mysql_schema_setup

    systemd_setup

}

python() {
  echo -e "${color} Installing Python 3.6 ${nocolor}"
  yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
  echo $?

  app_presetup

  echo -e "${color} downloading Application Dependencies ${nocolor}"
  cd ${app_path}
  pip3.6 install -r requirements.txt &>>/tmp/roboshop.log
  echo $?

 systemd_setup
}

Golang() {
  echo -e "${color} Installing Golang ${nocolor}"
  dnf install golang -y &>>/tmp/roboshop.log
  echo $?

  app_presetup

  echo -e "${color} downloading Application Dependencies ${nocolor}"
  cd ${app_path}
  go mod init dispatch &>>/tmp/roboshop.log
  go get &>>/tmp/roboshop.log
  go build &>>/tmp/roboshop.log
  echo $?

 systemd_setup
}


