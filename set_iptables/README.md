# Firewall
### Реализация кнокинг, взаимодействие с маршрутизацией.
1. Запустить nginx на centralServer.
2. Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
3. Пробросить 80й порт на inetRouter2 8080.
4. Дефолт в инет оставить через inetRouter.
5. Реализовать проход на 80й порт без маскарадинга.
6. Реализовать knocking port.
7. centralRouter может попасть на ssh inetrRouter через knock скрипт.

### Схема стенда
![](/set_iptables/pict/Screenshot%20from%202023-08-25%2012-39-14.png)

# Реализация
Разворачиваем стенд: \
`vagrant up`

#### 1. Запустить nginx на centralServer.
`ansible-playbook nginx-play.yml`

![](/set_iptables/pict/Screenshot%20from%202023-08-24%2017-55-17.png)

![](/set_iptables/pict/Screenshot%20from%202023-08-24%2017-55-52.png)

### 2. Проброс порта сайта
#### Реализоано через provision при развертывании.
- Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
- Дефолт в инет оставить через inetRouter.
- Пробросить 80й порт на inetRouter2 8080.
- Реализовать проход на 80й порт без маскарадинга.
### Gateway через inetRouter
![](/set_iptables/pict/Screenshot%20from%202023-08-25%2017-34-09.png)
### iptables 
![](/set_iptables/pict/Screenshot%20from%202023-08-25%2012-59-05.png)
### Проброс порта на пограничном роутере inetRouter
Можно сделать через `Vagrantfile` \
`box.vm.network "forwarded_port", guest: 8080, host: 14725, host_ip: "127.0.0.1", id: "http"` \
Использовал ручной проброс через GUI специально для наглядности, так понятнее, что происходит и как реализовано. \
Имитация пограничного роутера.

![](/set_iptables/pict/Screenshot%20from%202023-08-25%2012-41-34.png)

Как это выгледит с хостовой машины при запросе страницы сайта.

![](/set_iptables/pict/Screenshot%20from%202023-08-25%2010-16-40.png)

А так на роутере при пересылке пакетов

![](/set_iptables/pict/Screenshot%20from%202023-08-25%2013-08-36.png)

### 3. Knocking port
Выполнить роль: \
`ansible-playbook route-knock-play.yml` \
Реализация схемы правил knoking использует [статью](https://system.ru/nest/post/267/).
#### Проверка
1. Заходим на сервер `office` 
2. Выполним запуск скрипта из дериктории пользователя `vagrant` `run-knock.sh` 
3. В течении 30 секунд запустить попытку входа на сервер `inetRouter` `ssh vagrant@10.10.10.1` 

Так отрабатывает скрипт и попытки входа на сервер. Логинимся с `office -> inetRouter`

![](/set_iptables/pict/Screenshot%20from%202023-08-25%2017-30-14.png)

