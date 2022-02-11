# Vagrant File - teste com infra estrutura de servidores debian
# Servidores construidos :
# 
# - zabbix
# - database MariaDB
#
# A implementação do servidor DB esta desativada para correção do acesso frontend do Zabbix
# O banco de dados sera instalado em localhost no servdiro Zabbix

machines = {
  "zabbix" => {"memory" => "1024", "cpu" => "2", "ip" => "190", "image" => "debian/bullseye64"},
  #"database" => {"memory" => "1024", "cpu" => "2", "ip" => "191", "image" => "debian/bullseye64"}
}

Vagrant.configure("2") do |config|
  machines.each do |name, conf|
    config.vm.define "#{name}" do |machine|
     machine.vm.box = "#{conf["image"]}"
     machine.vm.hostname = "#{name}.exemplo.com.br" # -> Aqui voce seta o dominio para acesso via FQDN
     machine.vm.network "public_network", ip: "192.168.2.#{conf["ip"]}" # -> Aqui voce deve alterar para sua rede LAN 
     machine.vm.provider "virtualbox" do |vb|
      vb.name = "#{name}"
      vb.memory = conf["memory"]
      vb.cpus = conf["cpu"]
      vb.customize ["modifyvm", :id, "--groups", "/ZABBIX_Lab"] # -> Cria um grupo no VirtualBox (Apenas para organização)
    end
    if "#{name}" == "zabbix"
      machine.vm.provision "shell", inline: <<-SHELL
      useradd admzabbix
      mkdir -p /home/admzabbix/scripts
      chown admzabbix:admzabbix /home/admzabbix -R
      chmod 770 /home/admzabbix -R
      timedatectl set-timezone America/Sao_Paulo
      
      cat <<EOF > /home/admzabbix/scripts/README
      
      #####################################################
      #    Executar o Script instalacaoZabbixServer.sh    #
      #                                                   #
      #    Seguir os passos descritos ao final da         #  
      #    execução do Script.                            #
      #                                                   # 
      #####################################################
EOF
      cat <<EOF > /home/admzabbix/scripts/instalacaoZabbixServer.sh
#/bin/sh
#
# Autor  : Marciods | m4rc10d5
# Data   : 10/02/2022
# Versão : 0.9
#
# Script para realização da instalação e pre-configuração do servidor Zabbix Server 
#
#Instalação do repositorio do Zabbix 
wget https://repo.zabbix.com/zabbix/5.4/debian/pool/main/z/zabbix-release/zabbix-release_5.4-1+debian11_all.deb
dpkg -i zabbix-release_5.4-1+debian11_all.deb
apt update

#Instalação do Zabbix server, frontend, agent
apt install zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent -y

#Configurando o acesso ao banco de dados
#Editando o arquivo /etc/zabbix/zabbix_server.conf
sed -i 's/\#\ DBPassword=/DBPassword=password/ g ' /etc/zabbix/zabbix_server.conf


#Configuração do PHP para o frontend do Zabbix
#Edite o arquivos /etc/zabbix/nginx.conf, descomentando as linas que conten 'listen' e 'server_name'.
sed -i 's/^#// g ' /etc/zabbix/nginx.conf
sed -i 's/example.com/zabbix.exemplo.com.br/ g ' /etc/zabbix/nginx.conf

#Configurando o Vhost zabbix.<SEUDOMINIO>.com.br
cp /etc/zabbix/nginx.conf /etc/nginx/sites-available/zabbix.conf
ln -s /etc/nginx/sites-available/zabbix.conf /etc/nginx/sites-enabled/zabbix.conf

#Iniciando os serviços do Zabbix Server e Zabbix Agent
#Setando a inicialização com o boot

systemctl stop zabbix-server zabbix-agent nginx php7.4-fpm 
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
echo "#        Entrar no console do MariqDB ** SENHA EM BRANCO *** so dar Enter        #"
echo "#        -> mysql -uroot -p                                                      #"
echo "#                                                                                #"
echo "#        Criar o banco de dados do Zabbix e setar a codificão:                   #"
echo "#        -> create database zabbix character set utf8 collate utf8_bin;          #"
echo "#                                                                                #"
echo "#        Criar o usuario de acesso ao banco e a SENHA                            #"
echo "#        -> create user zabbix@localhost identified by 'password';               #"
echo "#                                                                                #"
echo "#        Dar as permissões necessárias para o usuario manipular o database       #"
echo "#        -> grant all privileges on zabbix.* to zabbix@localhost;                #"
echo "#                                                                                #"
echo "#        Sair do console do MySql/Mariadb                                        #"
echo "#        -> exit;                                                                #"
echo "#                                                                                #"
echo "#        Popular o banco de dados                                                #"
echo "#        -> arquivosql=/usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz     #" 
echo "#        -> zcat \$arquivosql | mysql -uzabbix -Dzabbix  -p                      #"
echo "#                                                                                #"
echo "#        * Será solicitado a senha apos a execução do comando acima              #"
echo "#                                                                                #"
echo "#                                                                                #"
echo "#--------------------------------------------------------------------------------#"


# Finalize a instalação do zabbix pelo frontend acessando http://ip_do_zabbix/
EOF
      chmod a+x /home/admzabbix/scripts/instalacaoZabbixServer.sh
      SHELL
    end
    #if "#{name}" == "database"
    #  machine.vm.provision "shell", path: "pacotes_svr-web-node2.sh"
    #end
  end
end
end