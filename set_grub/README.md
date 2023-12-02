## Загрузка системы
### Попасть в систему без пароля несколькими способами
#### /etc/default/grub
```
...
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
#GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""

# Uncomment to enable BadRAM filtering, modify to suit your needs
...
```
```
root@user-Standard-PC-Q35-ICH9-2009:/home/user# update-grub
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/init-select.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.2.0-20-generic
Found initrd image: /boot/initrd.img-6.2.0-20-generic
Found memtest86+x64 image: /boot/memtest86+x64.bin
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
done
```
```
1. 
Перезагружаем компьютер.
При входе в GRUB нажимаем клавишу «e» (редактировать).
Заходим в строку ядра и вводим команду rw init = / bin / bash за линией, которая будет иметь вид

menuentry 'Ubuntu' --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-7ec4b8dd-5bdb-4bca-bfa8-cdccaad038a0' {
        recordfail
        load_video
        gfxmode $linux_gfx_mode
        insmod gzio
        if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
        insmod part_gpt
        insmod ext2
        search --no-floppy --fs-uuid --set=root 7ec4b8dd-5bdb-4bca-bfa8-cdccaad038a0
        linux   /boot/vmlinuz-6.2.0-20-generic root=UUID=7ec4b8dd-5bdb-4bca-bfa8-cdccaad038a0 rw  init=/bin/bash
        initrd  /boot/initrd.img-6.2.0-20-generic
}

запускаем ctrl+x

2.
До нaчaлa зaгрузки оперaционной системы изменить пaрaметры зaгрузки ядрa в меню зaгрузчикa GRUB. Зaгрузить оперaционную систему в однопользовaтельском режиме (single-user mode). Зaдaть новый root-пaроль без вводa стaрого пaроля.

menuentry 'Ubuntu' --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-7ec4b8dd-5bdb-4bca-bfa8-cdccaad038a0' {
        recordfail
        load_video
        gfxmode $linux_gfx_mode
        insmod gzio
        if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
        insmod part_gpt
        insmod ext2
        search --no-floppy --fs-uuid --set=root 7ec4b8dd-5bdb-4bca-bfa8-cdccaad038a0
        linux   /boot/vmlinuz-6.2.0-20-generic root=UUID=7ec4b8dd-5bdb-4bca-bfa8-cdccaad038a0 rw single
        initrd  /boot/initrd.img-6.2.0-20-generic
}

3.
Примонтируйте линукс-рaздел комaндой sudo mount /dev/sda1 /media/linx_part. Измените рутa в примонтировaнном рaзделе — sudo chroot /media/sda1. Используйте passwd для изменения текущего пaроля нa новый. Reboot

```

### Установить систему с LVM, после чего переименовать VG
```
root@system:/home/vagrant# vgs
  VG        #PV #LV #SN Attr   VSize   VFree 
  ubuntu-vg   1   1   0 wz--n- <17.78g <7.78g

root@system:/home/vagrant# vgrename ubuntu-vg systemfs-vg
  Volume group "ubuntu-vg" successfully renamed to "systemfs-vg"

меняем упоменания старого девайсмапа на новый
 linux   /vmlinuz-5.4.0-148-generic root=/dev/mapper/systemfs--vg-ubuntu--lv ro single nomodeset dis_ucode_ldr ipv6.disable=1
root@system:/home/vagrant# mkinitramfs -v -o /boot/initramfs-$(uname -r).img $(uname -r)
Copying module directory kernel/drivers/usb/host
(excluding hwa-hc.ko sl811_cs.ko sl811-hcd.ko u132-hcd.ko whci-hcd.ko)
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/usb/host/ehci-fsl.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/usb/host/oxu210hp-hcd.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/usb/host/max3421-hcd.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/usb/host/xhci-plat-hcd.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/usb/host/isp116x-hcd.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/ssb/ssb.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/usb/host/ssb-hcd.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/usb/host/fotg210-hcd.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/usb/host/r8a66597-hcd.ko
Adding module /lib/modules/5.4.0-148-generic/kernel/drivers/bcma/bcma.ko
...
root@system:/home/vagrant# reboot

vagrantÄsystem:ü$ sudo vgs
  VG      #PV #LV #SN Attr   VSize   VFree 
  system-vg   1   1   0 wz--n- <17.78g <7.78g
```
### Добавить модуль в initrd

```
vagrantÄsystem:ü$ mkdir /etc/initramfs-tools/scripts/01test 
vagrantÄsystem:ü$ sudo vim /usr/lib/dracut/modules.d/01test/module_setup.sh 
vagrantÄsystem:ü$ sudo vim /usr/lib/dracut/modules.d/01test/test.sh 
vagrantÄsystem:ü$ sudo update-initramfs -u
vagrantÄsystem:ü$ lsinitramfs -l /boot/initramfs-$(uname -r).img $(uname -r) ø grep test
drwxr-xr-x   2 root     root            0 Jun  4 16:03 scripts/01test
-rw-r--r--   1 root     root           75 Jun  4 16:03 scripts/01test/ORDER
-rwxr-xr-x   1 root     root          251 Jun  4 15:58 scripts/01test/module_setup.sh
-rwxr-xr-x   1 root     root          332 Jun  4 15:58 scripts/01test/test.sh
-rwxr-xr-x  93 root     root            0 Nov 24  2021 usr/bin/test
-rw-r--r--   1 root     root         8681 Apr 18 08:31 usr/lib/modules/5.4.0-148-generic/kernel/crypto/asymmetric_keys/pkcs7_test_key.ko
-rw-r--r--   1 root     root        37217 Apr 18 08:31 usr/lib/modules/5.4.0-148-generic/kernel/drivers/spi/spi-loopback-test.ko
```