#!/bin/sh
user="admzabbix"
admzabbix="/home/admzabbix"
touch /tmp/zabbix_tmp.log && chmod 777 /tmp/zabbix_tmp.log
log="/tmp/zabbix_tmp.log"

# Verificando se o usuario e diretorio home do usuario admzabbix existe, caso não existir cria o usuario e o diretorio e da as permissões necessárias
getent passwd $user > /dev/null 2&>1
if [ $? -eq 0 ]; 
    then echo "$user ja existe." >>$log
    else useradd $user
fi
if [ -d $admzabbix ]
    then echo "$admzabbix ja existe" >>$log 
    else
        mkdir -p $admzabbix
        chown cda:cda $admzabbix -R
        chmod 770 $admzabbix -R
fi

apt update &&
apt install git vim -y &&
timedatectl set-timezone America/Sao_Paulo
cd /home/admzabbix
su cda
ssh-keygen -b 2048 -t rsa -f id_rsa -q -N '' &&
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
git config --global user.name "marciocdati"
git config --global user.email "marcio.ti@casasdaagua.com.br"
git clone https://github.com/marciocdati/zabbix_cda.git