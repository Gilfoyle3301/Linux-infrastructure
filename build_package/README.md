## Собрать Пакет из исходников
### vagrant up  поднимет виртуаку и начнет процесс сборки
```
Создание файлов сборки

Для выполнения сборки нужно создать, минимум, 4 файла.

1. Control-файл.

Это основной файл с описанием процесса сборки. Вводим:

vi debian/control

Пример для нашего случая:

Source:                 nginx
Section:                misc
Priority:               optional
Maintainer:             Gilfoyle <system@gmail.com>
Build-Depends:          libpcre3-dev,
                        zlib1g-dev
Standards-Version:      1.25.0
Homepage:               https://nginx.org

Package:                nginx
Architecture:           amd64
Provides:               nginx
Description: NGINX packages.
 The description can be written in several lines.
 Each line have to be 73 chars maximum.

* значения для опции Build-Depends задаются экспериментально — лучше всего попробовать сначала собрать требуемый пакет вручную, чтобы понять, какие потребуется доустановить пакеты. Рекомендуется это делать на чистой системе, чтобы не получить искаженный результат (на используемой системе уже могут быть пакеты, которых не будет на другом компьютере, где будет происходить сборка).
* более подробное описание файла control представлено ниже.

2. Файл changelog.

В данном файле описывается история изменений пакета. Также сборщик берет из этого файла номер версии и релиза.

Создаем файл командой:

vi debian/changelog

nginx (1.25.0) stable; urgency=medium
  * Initial release
 -- Gilfoyle <system@gmail,com>  Tue, 28 May 2023 17:34:42 +0300

3. Файл rules.

Описываем правила компиляции пакета во время его сборки. Создаем файл:

vi debian/rules

#!/usr/bin/make -f
export DH_VERBOSE = 1

url='http://nginx.org/download/nginx-1.20.1.tar.gz'
build_dir='nginx'

override_dh_auto_clean:
	if [ ! -f $(build_dir) ]; then rm -rf $(build_dir); fi
	mkdir $(build_dir)
	dh_auto_clean

override_dh_auto_configure:
	wget $(url) -O $(build_dir).tar.gz
	tar -xzf $(build_dir).tar.gz -C $(build_dir)/ --strip-components=1
	rm -f $(build_dir).tar.gz
	cd $(build_dir) && ./configure

override_dh_usrlocal:

%:
	dh $@ --sourcedirectory=$(build_dir)/

* важно обратить внимание на факт, что содержимое файла может сильно отличаться в зависимости от того, что мы собираем и какой версии собираемое программное обеспечение. В данном примере мы создали файл для независимой работы — сборщик сам скачает исходник и распакует его в рабочий каталог (в данном примере, nginx). Также мне пришлось переопределить этап dh_usrlocal, так как на нем возникала ошибка, связанная с невозможностью удалить каталог командой rmdir.
* в нашей системе должен быть установлен wget, как и все остальные утилиты, которыми мы захотим воспользоваться.
* более подробное описание файла rules ниже.

4. Файл compat.

Указываем на уровень совместимости с debhelper (вспомогательный инструмент для сборки пакетов). Создаем файл:

vi debian/compat

9

* нам необходимо использовать версию в соответствии с версией Debian, на основе которой организован дистрибутив Linux, в котором идет сборка — в нашем примере 9. Сама по себе сборка без данного файла (или при указании версии ниже текущей, на дистрибутиве которого собирается пакет) запустится, но быстро остановится с ошибкой dh_auto_clean: Compatibility levels before 9 are deprecated (level X in use), где Х — текущий уровень совместимости.
```
## Сборка пакета

#### У нас созданы все необходимые файлы, выполнены предварительные действия, и мы готовы к сборке. Проверяем, что у нас установлены необходимые пакеты и, при необходимости, установим их:
```
mk-build-deps --install
```
* команда является частью пакета equivs, который мы установили в начале инструкции. Она читает опцию Build-Depends файла control и устанавливает необходимые пакеты.

#### Для запуска утилиты в тихом режиме (без запросов на подтверждения) команду можно ввести так:
```
    echo yes | mk-build-deps -ri
```
```
Выполним сборку командой:

debuild -us -uc -b

Если мы все сделали правильно, в конце мы увидим что-то на подобие:

W: nginx: missing-depends-line
E: nginx: dir-in-usr-local usr/local/nginx/logs/
E: nginx: dir-in-usr-local usr/local/nginx/sbin/
E: nginx: file-in-usr-local usr/local/nginx/sbin/nginx
W: nginx: file-in-unusual-dir usr/local/nginx/sbin/nginx
Finished running lintian.

Пакет сформирован и должен находится в директории на уровень ниже:

ls ../

Среди списка файлов мы должны увидеть пакет с нашим названием:

nginx-1.25.0              nginx_1.25.0_amd64.build      nginx_1.25.0_amd64.changes
nginx-dbgsym_1.25.0_amd64.deb  nginx_1.25.0_amd64.buildinfo  nginx_1.25.0_amd64.deb
```