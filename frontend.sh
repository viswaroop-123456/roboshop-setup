echo -e"[35m installing nginx/[0"
dnf install nginx -y
echo -e"[35m removing old content/[0"
rm -rf /usr/share/nginx/html/*
echo -e"[35m downloading fontend content/[0"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e"[35m exctacting downloading frontend/[0"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e"[35m coping nginx roboshop for config/[0"
cp configs/nginx-roboshop-conf etc/nginx/default.d/roboshop.conf
echo -e"[35m enabling nginx/[0"
systemctl enable nginx
echo -e"[35m starting nginx/[0"
systemctl restart nginx