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

## Antigravity

O Antigravity não tem CLI própria. Depois de instalar o T3 Code:

1. Abra o T3 Code e acesse **Configurações > Providers**.
2. Ative o provider **Antigravity**.
3. O T3 baixa o pacote gerenciado (`agy_acp_server`) e conclui o login da conta Google no primeiro uso.

## Rodando sem interação

As perguntas sobre as ferramentas de IA aceitam variáveis de ambiente, o que permite automatizar a instalação:

```bash
# Instala Codex e OpenCode, pula o T3 Code/Antigravity
INSTALL_CODEX=1 INSTALL_OPENCODE=1 INSTALL_ANTIGRAVITY=0 ./setup.sh
```

Valores aceitos: `1`, `true`, `s`, `sim`, `y`, `yes` para instalar; qualquer outro valor (ou vazio, com Enter) para pular.
