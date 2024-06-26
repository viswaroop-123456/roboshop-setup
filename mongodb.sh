source common.sh
print_head "setup mongodb repository"
cp ${cod_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "install mongodb"
dnf install mongodb-org -y &>>${log_file}
status_check $?

print_head "update mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check $?

print_head "enable mongodb"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "start mongodb services"
systemctl restart mongod &>>${log_file}
status_check $?


