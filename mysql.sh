source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
echo -e "\e[31mMissing root password missing argument\e[0m"
exit 1
fi

print_head "disabling mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "coping mysql repo file"
cp ${cod_dir}/config/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?


print_head "installing mysql server"
dnf install mysql-community-server -y &>>${log_file}
status_check $?

print_head "enabling mysql server"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "start mysql server"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "set root password"
echo show databases | mysql -uroot -p${mysql_root_password} &>>${log_file}
if [ $? -ne 0 ]; then
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
fi
status_check $?



