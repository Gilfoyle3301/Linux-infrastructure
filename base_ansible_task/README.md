```
vagrant up - развернет 2 ВМ server/client
после необходимо зайти на сервер vagrant ssh server и выполнитьь команду ansible-playbook app/main.yaml
будет развернут nginx с кастомной конфигурацией и включен в автозагрузку

vagrant@system-client-nfs:~$ sudo systemctl list-unit-files --type=service --state=enabled | grep nginx
nginx.service                          enabled enabled      
```

