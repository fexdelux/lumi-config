# Instalação experimental
Não execute em produção sem backup. Use cartão separado e fonte estável. O script exige SHA completo da aplicação e driver, locks reais, versão uv e instalador Ollama revisado. A aplicação ainda precisa ser publicada a partir do Raspberry. Não há instalação zero-touch homologada.

1. Instale Raspberry Pi OS Lite ARM64 / Debian 13; habilite SSH conforme necessidade, crie usuário normal com sudo, verifique vcgencmd get_throttled (0x0).
2. Clone lumi-config, copie manifests/versions.env.example para local.env. Preencha SHA de lumi e LCD-show; use versão uv observada e obtenha binário ARM64 da release oficial, verificando checksum. Coloque em ~/.local/bin/uv.
3. Exporte no protótipo os locks sem publicar caminhos pessoais: ~/.venvs/ovos/bin/python -m pip freeze; ~/.local/bin/uv pip freeze --python ~/.venvs/ovos312/bin/python. Revise linhas editáveis e referências file://; skills próprias são instaladas separadamente. Use constraints-stable.txt do protótipo. Informe caminhos absolutos em local.env.
4. Revise o instalador oficial Ollama da versão 0.40.18 e seu checksum; confirme que ele instala a versão correta. Tags de modelos ainda não fixadas por digest.
5. Execute bash install.sh --dry-run. Configure memória (memory.md), LCD (lcd.md), então execute etapas com bash install.sh --only NOME ou --apply. Para retomar, após revisar o estado existente e backup, use ALLOW_EXISTING=yes em local.env. Não é mecanismo automático de rollback.
6. Faça logout/login após alteração de grupos; verifique acesso a framebuffer/input/audio. Calibração por unidade obrigatória. Não habilite comandos reais de energia.
7. Execute bash doctor.sh e docs/validation.md. Não considere sucesso de serviço equivalente a teste físico.

O script não altera fstab, boot config ou regra Polkit automaticamente; são ações deliberadas do operador. Não sobrescreva uma instalação ativa. Templates Systemd podem substituir unidades existentes apenas após autorização local explícita.
