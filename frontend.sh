code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm-f ${log_file}

echo -e"/e[35m installing nginx/[0m"
dnf install nginx -y&>>${log_file}
echo -e"/e[35m removing old content/[0m"
rm -rf /usr/share/nginx/html/*&>>${log_file}
echo -e"/e[35m downloading fontend content/[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip&>>${log_file}
echo -e"/e[35m exctacting downloading frontend/[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip&>>${log_file}
echo -e"/e[35m coping nginx roboshop for config/[0m"
cp configs/nginx-roboshop-conf etc/nginx/default.d/roboshop.conf&>>${log_file}
echo -e"/e[35m enabling nginx/[0m"
systemctl enable nginx&>>${log_file}
echo -e"/e[35m starting nginx/[0m"
systemctl restart nginx&>>${log_file}
