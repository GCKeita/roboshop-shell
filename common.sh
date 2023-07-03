color="\e[35m"
nocolor="\e[0m"
log_file=/tmp/roboshop.log
app_path="/app"

nodejs() {
    echo -e "${color} Configuring NodeJS Repo ${nocolor}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

    echo -e "${color} Installing NodeJS ${nocolor}"
    yum install nodejs -y &>>$log_file

    echo -e "${color}Adding application User ${nocolor}"
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

    echo -e "${color} Starting $Component service ${nocolor}"
    systemctl daemon-reload &>>$log_file
    systemctl enable $component &>>$log_file
    systemctl restart $component &>>$log_file
}

mongo_schema_setup() {
    echo -e "${color} Copying MongoDB Repo file ${nocolor}"
    cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$log_file

    echo -e "${color} Installing MongoDB Client ${nocolor}"
    yum install mongodb-org-shell -y &>>$log_file

    echo -e "${color} Loading Schema ${nocolor}"
    mongo --host Mmongodb-dev.gckeita-devops.com ${app_path}/schema/$component.js &>>$log_file
}