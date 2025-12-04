#!/bin/bash

source ./common.sh

check_root

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $?  "Enabling nodejs:20 version"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOG_FILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOG_FILE
    VALIDATE $? "Creating expense user"
else
    echo -e "Expense user already created...$Y SKIPPING $N"
fi

mkdir -p /app &>>$LOG_FILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "Extracted backend code"

npm install &>>$LOG_FILE
VALIDATE $? "Installing nodejs dependencies"

cp /home/ec2-user/expense-shellnew/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE
VALIDATE $? "Copied backend service"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "Daemon reload"

systemctl start backend &>>$LOG_FILE
VALIDATE $? "Starting backend"

systemctl enable backend &>>$LOG_FILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL Client"

mysql -h db.soumyadevops.space -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOG_FILE
VALIDATE $? "Restarting Backend"




