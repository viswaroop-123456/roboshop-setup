source common.sh

print_head "installing nginx"
dnf install nginx -y &>>${log_file}
status_check $?

print_head "removing old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status_check $?

print_head "downloading fontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?

print_head "extracting downloading frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

print_head "coping nginx roboshop for config"
cp ${cod_dir}/config/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

print_head "enabling nginx"
systemctl enable nginx &>>${log_file}
status_check $?

print_head "starting nginx"
systemctl start nginx &>>${log_file}
status_check $?
