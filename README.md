# setup-infotera

Script de preparação de máquina de desenvolvimento da Infotera.

## Como usar

Dê permissão de execução e rode:

```bash
sudo chmod +x setup.sh
./setup.sh
```

O script é interativo: pergunta a versão do Java e quais ferramentas de IA instalar (todas opcionais).

## O que é instalado

Obrigatório (quando aplicável à máquina):

- Google Chrome
- Apache NetBeans
- MySQL Workbench
- gedit
- Flameshot
- Git
- Postman
- IntelliJ IDEA Ultimate
- Node.js 22
- PHP 7.3 e PHP 8.1
- Composer

Opcionais (o script pergunta antes; o padrão é **não instalar**):

- **Codex CLI** — `npm install -g @openai/codex`
- **OpenCode** — instalador oficial em <https://opencode.ai/install>
- **T3 Code** — necessário para o provider **Antigravity** (via <https://t3.codes/install.sh>)
- **Modo sempre ativo** — não suspende com a tampa fechada e fixa a máquina em performance máxima

## Antigravity

O Antigravity não tem CLI própria. Depois de instalar o T3 Code:

1. Abra o T3 Code e acesse **Configurações > Providers**.
2. Ative o provider **Antigravity**.
3. O T3 baixa o pacote gerenciado (`agy_acp_server`) e conclui o login da conta Google no primeiro uso.

## Modo sempre ativo (opcional)

Pensado para máquinas que precisam ficar ligadas rodando o T3 Code (por exemplo, um servidor de agentes). Quando habilitado:

- cria `/etc/systemd/logind.conf.d/99-sempre-ativo.conf`, ignorando a tampa e a inatividade (`HandleLidSwitch=ignore`, `IdleAction=ignore`);
- mascara `sleep.target`, `suspend.target`, `hibernate.target` e `hybrid-sleep.target`;
- instala `t3-performance.service`, que fixa `scaling_governor`, `energy_performance_preference` e `platform_profile` em `performance` a cada boot (e tenta `powerprofilesctl set performance`).

O bloqueio da suspensão vale na hora; a configuração do `logind` passa a valer no próximo boot (ou após `sudo systemctl restart systemd-logind`).

Em notebooks isso aumenta o consumo de bateria e o aquecimento. O modo não impede o desligamento no nível crítico de bateria definido pelo UPower.

### Como reverter

```bash
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
sudo systemctl disable --now t3-performance.service
sudo rm -f /etc/systemd/logind.conf.d/99-sempre-ativo.conf \
           /etc/systemd/system/t3-performance.service \
           /usr/local/sbin/t3-performance.sh
sudo systemctl daemon-reload
```

## Rodando sem interação

As perguntas sobre as ferramentas de IA aceitam variáveis de ambiente, o que permite automatizar a instalação:

```bash
# Instala Codex e OpenCode, pula o T3 Code/Antigravity e o modo sempre ativo
INSTALL_CODEX=1 INSTALL_OPENCODE=1 INSTALL_ANTIGRAVITY=0 SETUP_ALWAYS_ON=0 ./setup.sh
```

Valores aceitos: `1`, `true`, `s`, `sim`, `y`, `yes` para instalar; qualquer outro valor (ou vazio, com Enter) para pular.
