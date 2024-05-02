code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}
print_head(){
  echo -e " \e[35m$1\e[0m "
}
print_head"setup mongodb repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo
print_head"install mongodb"
dnf install mongodb-org -y
print_head"enable mongodb"
systemctl enable mongod
print_head"start mongodb services"
systemctl start mongod
