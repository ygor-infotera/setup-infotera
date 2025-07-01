#!/bin/bash

# Função para verificar erros
check_error() {
    if [ $? -ne 0 ]; then
        echo "Erro: $1"
        exit 1
    fi
}

echo -e "\e[34mIniciando a instalação do sistema, DEV!\e[0m"
echo "Este script instalará as seguintes ferramentas:"
echo "- Google Chrome"
echo "- JetBrains Toolbox (para IntelliJ IDEA)"
echo "- Apache NetBeans"
echo "- MySQL Workbench"
echo "- gedit"
echo "- Flameshot"
echo "- Git"
echo "- Postman"
echo "- Node"
echo "- PHP 7.3"
echo "- PHP 8.1"
echo "- Composer"
read -p "Pressione Enter para continuar ou Ctrl+C para cancelar..."

# Atualizar pacotes
echo "Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y
check_error "Falha ao atualizar pacotes"

# Instalar Java (usuário escolhe a versão ou opta por não instalar)
echo ""
echo "Escolha a versão do Java para instalar:"
echo "1) OpenJDK 11"
echo "2) OpenJDK 17"
echo "3) OpenJDK 21"
echo "4) Não instalar Java"
read -p "Digite o número da opção desejada (1/2/3/4): " JAVA_OPTION

case $JAVA_OPTION in
    1)
        JAVA_VERSION="11"
        ;;
    2)
        JAVA_VERSION="17"
        ;;
    3)
        JAVA_VERSION="21"
        ;;
    4)
        echo "Instalação do Java pulada pelo usuário."
        JAVA_VERSION=""
        ;;
    *)
        echo "Opção inválida. Instalando OpenJDK 17 por padrão."
        JAVA_VERSION="17"
        ;;
esac

# Se o usuário não escolheu pular
if [ -n "$JAVA_VERSION" ]; then
    # Verifica se a versão já está instalada
    if dpkg -l | grep -q "openjdk-${JAVA_VERSION}-jdk"; then
        echo "OpenJDK $JAVA_VERSION já está instalado. Pulando instalação."
    else
        echo "Instalando OpenJDK $JAVA_VERSION..."
        sudo apt install -y openjdk-${JAVA_VERSION}-jdk
        check_error "Falha ao instalar o OpenJDK $JAVA_VERSION"
    fi
fi

# Verificar arquitetura e instalar Google Chrome
ARCH=$(dpkg --print-architecture)
if [ "$ARCH" != "amd64" ]; then
    echo "Aviso: Google Chrome será pulado, pois este script baixa a versão amd64, mas sua arquitetura é $ARCH."
else
    if ! command -v google-chrome &> /dev/null; then
        echo "Instalando Google Chrome..."
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        check_error "Falha ao baixar o Google Chrome"
        sudo apt install -y ./google-chrome-stable_current_amd64.deb
        check_error "Falha ao instalar o Google Chrome"
        rm google-chrome-stable_current_amd64.deb
    else
        echo "Google Chrome já está instalado."
    fi
fi

# Instalar Apache NetBeans
if ! snap list netbeans &> /dev/null; then
    echo "Instalando Apache NetBeans..."
    sudo snap install netbeans --classic
    check_error "Falha ao instalar o NetBeans"
    if ! snap list netbeans &> /dev/null; then
        echo "Erro: NetBeans não foi instalado corretamente."
        exit 1
    fi
else
    echo "Apache NetBeans já está instalado."
fi

# Instalar MySQL Workbench
if ! snap list mysql-workbench-community &> /dev/null; then
    echo "Instalando MySQL Workbench..."
    sudo snap install mysql-workbench-community
    check_error "Falha ao instalar o MySQL Workbench"
    if ! snap list mysql-workbench-community &> /dev/null; then
        echo "Erro: MySQL Workbench não foi instalado corretamente."
        exit 1
    fi
else
    echo "MySQL Workbench já está instalado."
fi

# Instalar gedit
if ! command -v gedit &> /dev/null; then
    echo "Instalando gedit..."
    sudo apt install -y gedit
    check_error "Falha ao instalar o gedit"
else
    echo "gedit já está instalado."
fi

# Instalar Flameshot
if ! command -v flameshot &> /dev/null; then
    echo "Instalando Flameshot..."
    sudo apt install -y flameshot
    check_error "Falha ao instalar o Flameshot"
else
    echo "Flameshot já está instalado."
fi

# Instalar Git
if ! command -v git &> /dev/null; then
    echo "Instalando Git..."
    sudo apt install -y git
    check_error "Falha ao instalar o Git"
else
    echo "Git já está instalado."
fi

# Instalar Postman
if ! snap list postman &> /dev/null; then
    echo "Instalando Postman via Snap..."
    sudo snap install postman
    check_error "Falha ao instalar o Postman"
    if ! snap list postman &> /dev/null; then
        echo "Erro: Postman não foi instalado corretamente."
        exit 1
    fi
else
    echo "Postman já está instalado."
fi

# Instalar IntelliJ IDEA Ultimate
if ! snap list intellij-idea-ultimate &> /dev/null; then
    echo "Instalando IntelliJ IDEA Ultimate..."
    sudo snap install intellij-idea-ultimate --classic
    check_error "Falha ao instalar o IntelliJ IDEA Ultimate"
    if ! snap list intellij-idea-ultimate &> /dev/null; then
        echo "Erro: IntelliJ IDEA Ultimate não foi instalado corretamente."
        exit 1
    fi
else
    echo "IntelliJ IDEA Ultimate já está instalado."
fi

# Instalar Node.js 22
if ! command -v node &> /dev/null; then
    echo "Instalando Node.js 22..."
    curl -sL https://deb.nodesource.com/setup_22.x -o /tmp/nodesource_setup.sh
    sudo bash /tmp/nodesource_setup.sh
    check_error "Falha ao configurar o repositório NodeSource"
    sudo apt install -y nodejs
    check_error "Falha ao instalar o Node.js 22"
else
    echo "Node.js já está instalado."
fi

---

## Installing PHP 7.3 and PHP 8.1

To install multiple PHP versions, we first need to add the `ondrej/php` PPA, which provides various PHP versions.

```bash
# Adicionar PPA para PHP
echo "Adicionando PPA para PHP..."
sudo add-apt-repository -y ppa:ondrej/php
check_error "Falha ao adicionar PPA para PHP"
sudo apt update
check_error "Falha ao atualizar pacotes após adicionar PPA"

# Instalar PHP 7.3
echo "Instalando PHP 7.3 e módulos comuns..."
if ! command -v php7.3 &> /dev/null; then
    sudo apt install -y php7.3 php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-json php7.3-mbstring php7.3-mysql php7.3-opcache php7.3-readline php7.3-xml php7.3-zip
    check_error "Falha ao instalar PHP 7.3"
else
    echo "PHP 7.3 já está instalado."
fi

# Instalar PHP 8.1
echo "Instalando PHP 8.1 e módulos comuns..."
if ! command -v php8.1 &> /dev/null; then
    sudo apt install -y php8.1 php8.1-cli php8.1-common php8.1-curl php8.1-gd php8.1-mysql php8.1-mbstring php8.1-xml php8.1-zip php8.1-opcache php8.1-readline
    check_error "Falha ao instalar PHP 8.1"
else
    echo "PHP 8.1 já está instalado."
fi

---

## Installing Composer

Composer is a dependency manager for PHP. We'll install it globally.

```bash
# Instalar Composer
echo "Instalando Composer..."
if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    check_error "Falha ao instalar o Composer"
else
    echo "Composer já está instalado."
fi

# Mover a pasta ./wildfly para ~/programs/
echo "Verificando e movendo a pasta 'wildfly' para '~/programs/'..."

# Certifica-se de que o diretório de destino existe
mkdir -p ~/programs
check_error "Falha ao criar o diretório '~/programs'"

# Verifica se a pasta wildfly existe no diretório atual
if [ -d "./wildfly" ]; then
    mv ./wildfly ~/programs/
    check_error "Falha ao mover a pasta 'wildfly' para '~/programs/'"
    echo "Pasta 'wildfly' movida para '~/programs/'."
else
    echo "Pasta './wildfly' não encontrada. Pulando a movimentação."
fi

# Mover o arquivo settings.xml para ~/.m2/
echo "Verificando e movendo o arquivo 'settings.xml' para '~/.m2/'..."

# Cria o diretório ~/.m2 se ele não existir
mkdir -p ~/.m2
check_error "Falha ao criar o diretório '~/.m2/'"

# Verifica se o arquivo settings.xml existe no diretório atual
if [ -f "./settings.xml" ]; then
    mv ./settings.xml ~/.m2/settings.xml
    check_error "Falha ao mover o arquivo './settings.xml' para '~/.m2/'"
    echo "Arquivo 'settings.xml' movido para '~/.m2/settings.xml'."
else
    echo "Arquivo './settings.xml' não encontrado. Pulando a movimentação."
fi

# Limpar pacotes desnecessários
echo "Limpando pacotes desnecessários..."
sudo apt autoremove -y
sudo apt autoclean
check_error "Falha ao limpar pacotes"

echo -e "\e[32mSetup finalizado com sucesso, Agora é só brilhar!\e[0m"
