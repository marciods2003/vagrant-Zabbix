#/bin/sh
#
# Autor  : Marciods | m4rc10d5
# Data   : 10/02/2022
# Versão : 0.1
#
# Script para realização da instalação e pre-configuração do servidor Zabbix Server 
#
#Install Zabbix repository
wget https://repo.zabbix.com/zabbix/5.4/debian/pool/main/z/zabbix-release/zabbix-release_5.4-1+debian11_all.deb
dpkg -i zabbix-release_5.4-1+debian11_all.deb
apt update

#Install Zabbix server, frontend, agent
apt install zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent

#Configure the database for Zabbix server
#Edit file /etc/zabbix/zabbix_server.conf
sed -i 's/\#\ DBPassword=/DBPassword=cd\@gu\@\/30/ g ' /etc/zabbix/zabbix_server.conf


#Configure PHP for Zabbix frontend
#Edit file /etc/zabbix/nginx.conf, uncomment and set 'listen' and 'server_name' directives.
sed -i 's/^#// g ' /etc/zabbix/nginx.conf
sed -i 's/example.com/zabbix.casasdaagua.com.br/ g ' /etc/zabbix/nginx.conf
cp /etc/zabbix/nginx.conf /etc/nginx/sites-avaliable/zabbix.conf
ln -s /etc/nginx/sites-avaliable/zabbix.conf /etc/nginx/sites-enabled/zabbix.conf

#Start Zabbix server and agent processes
#Start Zabbix server and agent processes and make it start at system boot.

systemctl restart zabbix-server zabbix-agent nginx php7.4-fpm
systemctl enable zabbix-server zabbix-agent nginx php7.4-fpm

#Instalando o banco de dados Mariadb
apt install mariadb-server -y


echo "#--------------- Instalação Zabbix Server finalizada com sucesso! ---------------#"
echo "#                                                                                #"
echo "#                                                                                #"
echo "#        Agora voce precisa finalizar a configuração do banco de dados           #"
echo "#        realizado os passos (executando os comandos) a seguir :                 #"
echo "#                                                                                #"
echo "#        Entrar no console do MariqDB                                            #"
echo "#        -> mysql -uroot -p                                                      #"
echo "#                                                                                #"
echo "#        Criar o banco de dados do Zabbix e setar a codificão:                   #"
echo "#        -> create database zabbix character set utf8 collate utf8_bin;          #"
echo "#                                                                                #"
echo "#        Criar o usuario de acesso ao banco                                      #"
echo "#        -> create user zabbix@localhost identified by 'password';               #"
echo "#                                                                                #"
echo "#        Dar as permissões necessárias para o usuario manipular o database       #"
echo "#        -> grant all privileges on zabbix.* to zabbix@localhost;                #"
echo "#                                                                                #"
echo "#        Sair do console do MySql/Mariadb                                        #"
echo "#        -> exit;                                                                #"
echo "#                                                                                #"
echo "#        Popular o banco de dados                                                #"
echo "#        -> arquivosql="/usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz"   #" 
echo "#        -> zcat $arquivosql | mysql -uzabbix -Dzabbix  -p                       #"
echo "#                                                                                #"
echo "#        * Será solicitado a senha apos a execução do comando acima              #"
echo "#                                                                                #"
echo "#                                                                                #"
echo "#--------------------------------------------------------------------------------#"


# Finalize a instalação do zabbix pelo frontend acessando http://ip_do_zabbix/