source common.sh
print_head "installing nginx"
dnf install nginx -y &>>${log_file}

print_head "removing old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "downloading fontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "exctacting downloading frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_head "coping nginx roboshop for config"
cp configs/nginx-roboshop-conf etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "enabling nginx"
systemctl enable nginx &>>${log_file}

print_head "starting nginx"
systemctl restart nginx &>>${log_file}
