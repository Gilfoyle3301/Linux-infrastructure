# VPN
# Реализация
Для развертывания стенда с vpn в режиме tun/tap нужну выполнить следующие:
1. vagrant up
2. для режима tun/tap
```
 ansible-playbook ansible/vpn_tun_tap.yaml -e mode=tun or tap
```
3. для режима RAS
```
ansible-playbook ansible/vpn_ras.yaml
```
# Результат:
tap:

![](/set_vpn/image/tap.png)

tun:

![](/set_vpn/image/tun.png)


RAS:

![](/set_vpn/image/openvpn.png)