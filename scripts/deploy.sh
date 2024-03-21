#!/bin/bash
BUILD_JAR=$(ls /home/ec2-user/app/*-SNAPSHOT.jar)
JAR_NAME=$(basename $BUILD_JAR)
echo "> build cicd-test: $JAR_NAME" >> /home/ec2-user/app/deploy.log

echo "> build 파일 복사" >> /home/ec2-user/app/deploy.log
DEPLOY_PATH=/home/ec2-user/
cp $BUILD_JAR $DEPLOY_PATH

echo "> cicd-test.jar 교체"
CP_JAR_PATH=$DEPLOY_PATH$JAR_NAME
APPLICATION_JAR_NAME=cicd-test.jar
APPLICATION_JAR=$DEPLOY_PATH$APPLICATION_JAR_NAME

ln -Tfs $CP_JAR_PATH $APPLICATION_JAR

echo "> 현재 실행중인 애플리케이션 pid 확인" >> /home/ec2-user/app/deploy.log
CURRENT_PID=$(pgrep -f $APPLICATION_JAR_NAME)

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다." >> /home/ec2-user/app/deploy.log
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> $APPLICATION_JAR_NAME 배포"    >> /home/ec2-user/app/deploy.log
nohup java -jar $APPLICATION_JAR_NAME >> /home/ec2-user/deploy.log 2>/home/ec2-user/deploy_err.log &