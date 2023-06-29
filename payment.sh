
echo -e "\e[33m Installing Python 3.6 \e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

echo -e "\e[33m Downloading Application Content \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33m creating Application Directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[33m Downloading Application Content \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log

echo -e "\e[33m Extracting Application Content \e[0m"
cd /app
unzip /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[33m downloading Application Dependencies \e[0m"
cd /app
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

echo -e "\e[33m Seting SystemD File \e[0m"
cp /root/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log

echo -e "\e[33m Starting Payment Service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable payment &>>/tmp/roboshop.log
systemctl restart payment &>>/tmp/roboshop.log




