source common.sh
print_head"setup mongodb repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo
print_head"install mongodb"
dnf install mongodb-org -y
print_head"enable mongodb"
systemctl enable mongod
print_head"start mongodb services"
systemctl start mongod
