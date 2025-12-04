#!/bin/bash

source ./common.sh

check_root

dnf module disable nodejs -y &>>$LOG_FILE

dnf module enable nodejs:20 -y &>>$LOG_FILE

dnf install nodejs -y &>>$LOG_FILE

id expense &>>$LOG_FILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOG_FILE
else
    echo -e "Expense user already created...$Y SKIPPING $N"
fi

mkdir -p /app &>>$LOG_FILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOG_FILE

npm install &>>$LOG_FILE

cp /home/ec2-user/expense-shellnew/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE


systemctl daemon-reload &>>$LOG_FILE

systemctl start backend &>>$LOG_FILE

systemctl enable backend &>>$LOG_FILE

dnf install mysql -y &>>$LOG_FILE

mysql -h db.soumyadevops.space -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE

systemctl restart backend &>>$LOG_FILE




