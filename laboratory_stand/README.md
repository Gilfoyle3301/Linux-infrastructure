## Contour in DMZ sandbox area to conduct basic penetration testing training 

#### DMZ (англ. Demilitarized Zone — демилитаризованная зона, ДМЗ) — сегмент сети, содержащий общедоступные сервисы и отделяющий их от частных. В качестве общедоступного может выступать, например, веб-сервис: обеспечивающий его сервер, который физически размещён в локальной сети (Интранет), должен ### отвечать на любые запросы из внешней сети (Интернет), при этом другие локальные ресурсы (например, файловые серверы, рабочие станции) необходимо изолировать от внешнего доступа.

## stand diagram
![](/schema/SDMZ.svg)

### Для одной виртуальной машины: RAM: 1Gb | vCPU: 2

## Развертывание стенда
```
vagrant up
```
Запустит развертывание всех компонентов стенда.

## Результат:

### Развернуты две ноды лабаратории с сервером фронта
![](/schema/lab.png)

### Автоматически разворачивается настроенный мониторинг
![](/schema/monitor1.png)

![](/schema/monitor2.png)

### Настроен алертинг и уведомления в телеграмм
![](/schema/notification.png)

### Настроен backup
![](/schema/backup.png)

### Настроен сервер логирования
![](/schema/log.png)


### Настроена репликация базы данных
```
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for source to send event
                  Master_Host: 192.168.77.16
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000001
          Read_Master_Log_Pos: 157
               Relay_Log_File: dataBaseSlave-relay-bin.000003
                Relay_Log_Pos: 326
        Relay_Master_Log_File: mysql-bin.000001
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 157
              Relay_Log_Space: 724
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1
                  Master_UUID: ac13d861-9064-11ee-b546-080027616c61
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
       Master_public_key_path: 
        Get_master_public_key: 0
            Network_Namespace: 
1 row in set, 1 warning (0.00 sec)
```
### Примечания
#### DNS-сервер используется для внтреннего разрешения имен

## TO DO

1. [Настроить](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/) работу Grafana на reverse proxy
2. [Настроить](https://habr.com/ru/articles/185318/) оказоустойчивую систему на базе репликации mySQL и сетевого протокола CARP
3. Настроить почтовое оповещение при регистрации в системе.