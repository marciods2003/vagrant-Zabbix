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
      machine.vm.provision "shell", path: "scripts/zabbix.sh" # -> Executa um script inicial na criação da VM para alinhamento de alguns prametros
    end
    #if "#{name}" == "database"
    #  machine.vm.provision "shell", path: "pacotes_svr-web-node2.sh"
    #end
  end
end
end