source common.sh

print_head "configure nodejs repo"
#dnf module disable nodejs -y
#dnf module enable nodejs:18 -y &>>${log_file}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "install nodejs "
dnf install nodejs -y &>>${log_file}
status_check $?

print_head "create roboshop user"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
useradd roboshop &>>${log_file}
fi
status_check $?

print_head "make directory"
if [ ! -d /app ]; then
mkdir /app &>>${log_file}
fi
status_check $?

print_head "delete old content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "downloading app content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app
status_check $?

print_head "extracting app content"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "installing nodejs dependencies"
npm install &>>${log_file}
status_check $?

print_head "copy systemd service file"
cp ${cod_dir}/config/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "reload systemd"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable catalogue services"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "start catalogue services"
systemctl restart catalogue &>>${log_file}
status_check $?

print_head "copy mongodb services"
cp ${cod_dir}/config/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "install mongo client"
dnf install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "load schema"
mongo --host mongodb.devopsbatch.cloud </app/schema/catalogue.js &>>${log_file}
status_check $?



