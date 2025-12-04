# #!/bin/bash

# USERID=$(id -u)
# TIMESTAMP=$(date +%F-%H-%M-%S)
# SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
# LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# N="\e[0m"
# echo "please enter root password:"
# read -s mysql_root_password

# if [ $USERID -ne 0 ]
# then
#     echo "Please run this script with root access."
#     exit 1
# else
#     echo "You are super user."
# fi


# VALIDATE(){
#     if [ $1 -ne 0 ]
#     then 
#         echo -e "$2...$R FAILURE $N"
#         exit 1
#     else
#         echo -e "$2...$G SUCCESS $N"
#     fi
# }


# dnf install mysql-server -y &>>$LOGFILE
# VALIDATE $? "Installing MySQL Server"

# systemctl enable mysqld &>>$LOGFILE
# VALIDATE $? "Enabling MySQL Server"

# systemctl start mysqld &>>$LOGFILE
# VALIDATE $? "Starting MySQL Server"

# # mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# # VALIDATE $? "Setting  mysql root password"

# # Below code will be useful for idempotent nature
# mysql -h db.soumyadevops.space -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
# if [ $? -ne 0 ]
# then
#     mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
#     VALIDATE $? "MySQL Root password Setup"
# else
#     echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
# fi

#!/bin/bash

source ./common.sh

check_root

dnf install mysql-serjver -y &>>$LOGFILE

systemctl enable mysqld &>>$LOGFILE

systemctl start mysqld &>>$LOGFILE

mysql -h db.soumyadevops.space -u root -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    echo "MySQL root password is not setup, setting now" &>>$LOGFILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N"  &>>$LOGFILE
fi

# Assignment
# check MySQL Server is installed or not, enabled or not, started or not
# implement the above things