# OSPF

### Схема стенда
![](/set_ospf/image/schema.png)

# Реализация
Разворачиваем стенд: \
`vagrant up`

При деплое router3 запустится ansible-playbook, которая сконфигурирует роутеры.

# Ассиметричный роутинг 
После увеличения стоимости интерфейса enp0s8:

![](/set_ospf/image/pingask.png)

Результат traceroute:
![](/set_ospf/image/traceroute.png)


# Cиметричный роутинг 
Результат traceroute после увеличения стоимости интерфеса на соседне роутере:
![](/set_ospf/image/simtr.png)