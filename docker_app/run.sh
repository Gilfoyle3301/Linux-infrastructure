#!/bin/bash
echo "Остановка контейнеров"
docker stop $(docker ps -a | grep scrapper | awk '{print $1}')
docker stop $(docker ps -a | grep postgres | awk '{print $1}')
echo "Удаление контейнеров и образа парсера"
docker rm $(docker ps -a | grep postgres | awk '{print $1}')
docker rm $(docker ps -a | grep scrapper | awk '{print $1}')
docker rmi scrapper
#docker build -t scrapper .
echo "Запуск"
docker-compose -f main.yml up --build -d && docker exec -it $(docker ps -a | grep scrapper | awk '{print $1}') /bin/bash -c 'python3 scrapper.py'
