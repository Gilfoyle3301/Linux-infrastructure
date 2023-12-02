# Lesson 1:  Обновление ядра

### Задание

Научиться обновлять ядро в ОС Linux. Получение навыков работы с Vagrant, Packer и публикацией готовых образов в Vagrant Cloud


## описание команд и их вывод

### Vagrant
#### Используемые команды

```
vagrant up - запуск ВМ
vagrant box add <self box> - импортирует полученный vagrant box в Vagrant
vagrant ssh - подключается к виртуальной машине по SSH
vagrant halt - останавливает виртуальную машину
vagrant destroy - удаляет виртуальную машину
vagrant init - инициализация Vagrantfile
vagrant cloud publish --release - публикация образа
```

### Packer
#### Используемые команды


```
packer build <myVM>.json - Сборка образа ВМ 
packer validate <myVM>.json - Проверка манифеста

```

#### Пример успешного вывода сборки ОВМ

```
==> Builds finished. The artifacts of successful builds are:
--> ubuntu-20.04: 'virtualbox' provider box: ubuntu-20.04-6-x86_64.box
