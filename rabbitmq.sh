source common.sh

echo -e "${color} Configuring Erlang Repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Configuring Rabbitmq Repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Installing Rabbitmq server ${nocolor}"
yum install rabbitmq-server -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Starting Rabbitmq Service ${nocolor}"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl start rabbitmq-server &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} adding Rabbitmq Application User ${nocolor}"
rabbitmqctl add_user roboshop $1 &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log
stat_check $?
