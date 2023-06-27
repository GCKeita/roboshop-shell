echo -e "\e[33mInstalling Nginx Server\e[0m"
yum install nginx -y &>>/tmp/roboshop.log

echo -e "\e[33mRemoving old App content\e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log

echo -e "\e[33mDownloading Frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[33mExtracting Frontend content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[33mUpdating Frontend Configuration\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[33mStarting Nginx Server\e[0m"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl start nginx &>>/tmp/roboshop.log


