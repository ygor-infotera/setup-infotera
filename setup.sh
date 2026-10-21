#!/bin/bash

# Função para verificar erros
check_error() {
    if [ $? -ne 0 ]; then
        echo "Erro: $1"
        exit 1
    fi
}

# Pergunta sim/não com padrão "não".
# A resposta pode vir da variável de ambiente informada (ex.: INSTALL_CODEX=1),
# o que permite rodar o script sem interação.
# Uso: ask_optional "Pergunta?" INSTALL_CODEX
ask_optional() {
    local prompt="$1"
    local env_name="$2"
    local answer

    answer="${!env_name:-}"
    if [ -z "$answer" ]; then
        read -r -p "$prompt [s/N] " answer
    fi

    case "${answer,,}" in
        s|sim|y|yes|1|true) return 0 ;;
        *) return 1 ;;
    esac
}

echo -e "\e[34mIniciando a instalação do sistema, DEV!\e[0m"
echo "Este script instalará as seguintes ferramentas:"
echo "- Google Chrome"
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
echo ""
echo "Opcionais (o script pergunta antes de instalar):"
echo "- Codex CLI"
echo "- OpenCode"
echo "- T3 Code (para usar o provider Antigravity)"
echo "- Modo sempre ativo/performance (opcional)"
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

# Instalar ferramentas de IA (opcionais)
echo ""
echo "Ferramentas de IA: todas são opcionais, pressione Enter para pular."

# Codex CLI (OpenAI)
if ask_optional "Instalar Codex CLI (npm install -g @openai/codex)?" INSTALL_CODEX; then
    if command -v codex &> /dev/null; then
        echo "Codex CLI já está instalado."
    elif ! command -v npm &> /dev/null; then
        echo "Aviso: npm não encontrado, então o Codex CLI foi pulado."
    else
        echo "Instalando Codex CLI..."
        # Usa sudo apenas quando o diretório global do npm não é gravável
        # (evita instalar como root em instalações via nvm).
        if [ -w "$(npm root -g)" ]; then
            npm install -g @openai/codex
        else
            sudo npm install -g @openai/codex
        fi
        check_error "Falha ao instalar o Codex CLI"
    fi
else
    echo "Codex CLI pulado."
fi

# OpenCode
if ask_optional "Instalar OpenCode?" INSTALL_OPENCODE; then
    if command -v opencode &> /dev/null; then
        echo "OpenCode já está instalado."
    else
        echo "Instalando OpenCode..."
        OPENCODE_INSTALLER=$(mktemp)
        curl -fsSL https://opencode.ai/install -o "$OPENCODE_INSTALLER"
        check_error "Falha ao baixar o instalador do OpenCode"
        bash "$OPENCODE_INSTALLER"
        check_error "Falha ao instalar o OpenCode"
        rm -f "$OPENCODE_INSTALLER"
    fi
else
    echo "OpenCode pulado."
fi

# Antigravity (via T3 Code)
# O Antigravity não tem CLI própria: o T3 Code baixa e gerencia o pacote
# (agy_acp_server) quando o provider é ativado no app.
if ask_optional "Instalar T3 Code (necessário para o provider Antigravity)?" INSTALL_ANTIGRAVITY; then
    if command -v t3 &> /dev/null; then
        echo "T3 Code já está instalado."
    else
        echo "Instalando T3 Code..."
        T3_INSTALLER=$(mktemp)
        curl -fsSL https://t3.codes/install.sh -o "$T3_INSTALLER"
        check_error "Falha ao baixar o instalador do T3 Code"
        sh "$T3_INSTALLER"
        check_error "Falha ao instalar o T3 Code"
        rm -f "$T3_INSTALLER"
    fi
    echo "Para usar o Antigravity: abra o T3 Code, acesse Configurações > Providers"
    echo "e ative o provider Antigravity. O T3 baixa o pacote gerenciado e conclui"
    echo "o login da conta Google no primeiro uso."
else
    echo "T3 Code / Antigravity pulado."
fi

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

# Modo sempre ativo (opcional)
if ask_optional "Configurar modo sempre ativo (sem suspender e em performance máxima)?" SETUP_ALWAYS_ON; then
    echo "Configurando modo sempre ativo..."

    # Ignora tampa e inatividade no systemd-logind
    sudo install -d -m 755 /etc/systemd/logind.conf.d
    sudo tee /etc/systemd/logind.conf.d/99-sempre-ativo.conf > /dev/null <<'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
HandleSuspendKey=ignore
HandleHibernateKey=ignore
IdleAction=ignore
EOF
    check_error "Falha ao configurar o systemd-logind"

    # Bloqueia suspensão e hibernação
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    check_error "Falha ao bloquear suspensão/hibernação"

    # Script que reaplica performance máxima (governor, EPP e perfil da plataforma)
    sudo tee /usr/local/sbin/t3-performance.sh > /dev/null <<'EOF'
#!/bin/bash
# Coloca a máquina em modo de performance.
set -u

for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance > "$f" 2>/dev/null || true
done

for f in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
    echo performance > "$f" 2>/dev/null || true
done

if [ -w /sys/firmware/acpi/platform_profile ]; then
    echo performance > /sys/firmware/acpi/platform_profile 2>/dev/null || true
fi

powerprofilesctl set performance > /dev/null 2>&1 || true
exit 0
EOF
    sudo chmod 755 /usr/local/sbin/t3-performance.sh

    sudo tee /etc/systemd/system/t3-performance.service > /dev/null <<'EOF'
[Unit]
Description=Modo de performance (setup-infotera)
After=power-profiles-daemon.service multi-user.target
Wants=power-profiles-daemon.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/sbin/t3-performance.sh

[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl daemon-reload
    sudo systemctl enable --now t3-performance.service
    check_error "Falha ao ativar o modo de performance"

    echo "Modo sempre ativo configurado: tampa ignorada, suspensão bloqueada e performance máxima."
    echo "Para reverter, veja a seção 'Modo sempre ativo' no README."
else
    echo "Modo sempre ativo pulado."
fi

# Limpar pacotes desnecessários
echo "Limpando pacotes desnecessários..."
sudo apt autoremove -y
sudo apt autoclean
check_error "Falha ao limpar pacotes"

echo -e "\e[32mSetup finalizado com sucesso, Agora é só brilhar!\e[0m"
