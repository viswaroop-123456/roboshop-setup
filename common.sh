cod_dir=$(pwd)

log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e " \e[35m$1\e[0m "
}

status_check(){
  if [ $1 -eq 0 ]; then
    echo SUCCESS
    else
    echo FAILURE
    echo "read the log file ${log_file} for more information about the error"
    exit 1
    fi

}

schema_setup(){
  if [ "${schema_type}" == "mongo" ]; then
  print_head "copy mongo repo file "
  cp ${cod_dir}/config/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
  status_check $?

  print_head "install mongo client"
  dnf install mongodb-org-shell -y &>>${log_file}
  status_check $?

  print_head "load schema"
  mongo --host mongodb.devopsbatch.cloud </app/schema/${component}.js &>>${log_file}
  status_check $?
  fi
}
nodejs(){
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
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
cd /app
status_check $?

print_head "extracting app content"
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "installing nodejs dependencies"
npm install &>>${log_file}
status_check $?

print_head "copy systemd service file"
cp ${cod_dir}/config/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "reload systemd"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable ${component} services"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "start ${component} services"
systemctl restart ${component} &>>${log_file}
status_check $?

schema_setup

}

