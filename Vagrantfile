# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.hostname = "cloudnova-server"

  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 443, host: 8443, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 3000, host: 3000, host_ip: "127.0.0.1"   # Grafana
  config.vm.network "forwarded_port", guest: 9090, host: 9090, host_ip: "127.0.0.1"   # Prometheus
  config.vm.network "forwarded_port", guest: 9100, host: 9100, host_ip: "127.0.0.1"   # Node Exporter

  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.synced_folder ".", "/home/vagrant/parcial-telematicos"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "CloudNova-Parcial-Telematicos"
    vb.memory = "4096"
    vb.cpus = 2
    
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo "  Aprovisionando CloudNova - Parcial Telemáticos"
    echo "================================================"
    echo ""

    echo "Actualizando sistema..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get upgrade -y -qq

    echo "Instalando dependencias básicas..."
    apt-get install -y -qq \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      lsb-release \
      git \
      vim \
      net-tools \
      htop

    echo "Instalando Docker (repositorio oficial, versión moderna)..."
    if ! command -v docker &> /dev/null; then
      apt-get remove -y -qq docker.io docker-doc docker-compose podman-docker containerd runc || true

      install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      chmod a+r /etc/apt/keyrings/docker.gpg

      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
        > /etc/apt/sources.list.d/docker.list

      apt-get update -qq

      apt-get install -y -qq \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

      usermod -aG docker vagrant

      echo "Docker CE y plugin docker compose instalados correctamente"
    else
      echo "Docker ya está instalado"
    fi

    echo "Configurando comando docker-compose..."
    if ! command -v docker-compose &> /dev/null; then
      if [ -x /usr/libexec/docker/cli-plugins/docker-compose ]; then
        ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose || true
      elif [ -x /usr/lib/docker/cli-plugins/docker-compose ]; then
        ln -s /usr/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose || true
      fi
      echo "Alias docker-compose configurado (usa docker compose v2)"
    else
      echo "docker-compose ya está disponible"
    fi

    systemctl enable docker
    systemctl start docker

    echo ""
    echo "Verificando instalaciones..."
    docker --version
    docker compose version || docker-compose --version
    git --version

    echo ""
    echo "Configurando permisos..."
    chown -R vagrant:vagrant /home/vagrant/parcial-telematicos

    echo ""
    echo "================================================"
    echo "  Aprovisionamiento completado exitosamente"
    echo ""
    echo "Próximos pasos:"
    echo ""
    echo "  2. Ir al directorio del proyecto:"
    echo "     cd parcial-telematicos"
    echo ""
    echo "  3. Clonar MiniWebApp:"
    echo "     git clone https://github.com/omondragon/MiniWebApp.git"
    echo ""
    echo "  4. Integrar MiniWebApp:"
    echo "     ./integrate-miniwebapp.sh"
    echo ""
    echo "  5. Desplegar todo:"
    echo "     ./generate-ssl.sh"
    echo "     docker-compose build   # o: docker compose build"
    echo "     docker-compose up -d   # o: docker compose up -d"
    echo ""
    echo "  6. Verificar:"
    echo "     ./status.sh"
    echo ""
    echo "Acceso:"
    echo "  - Aplicación Web:  https://localhost:8443"
    echo "  - Grafana:         http://localhost:3000"
    echo "  - Prometheus:      http://localhost:9090"
    echo ""
  SHELL
end
