# Instalação experimental
Não execute em produção sem backup. Use cartão separado e fonte estável. O script exige SHA completo da aplicação e driver, locks reais, versão uv e instalador Ollama revisado. A tag v0.3.8 está publicada e o manifesto inclui os SHAs homologados da aplicação e driver, além de UV 0.13.10. Use SHA completo verificado, não uma branch móvel. Não há instalação zero-touch homologada.

1. Instale Raspberry Pi OS Lite ARM64 / Debian 13; habilite SSH conforme necessidade, crie usuário normal com sudo, verifique vcgencmd get_throttled (0x0).
2. Clone lumi-config, copie manifests/versions.env.example para local.env. Preencha SHA de lumi e LCD-show; use versão uv observada e obtenha binário ARM64 da release oficial, verificando checksum. Coloque em ~/.local/bin/uv.
3. Os locks Python homologados no protótipo estão em manifests/locks (34 pacotes Bus, 71 Core). Deixe BUS_LOCK, CORE_LOCK e CONSTRAINTS vazios em local.env para usar esses arquivos. O preflight verifica SHA256SUMS. Overrides opcionais devem apontar para arquivos absolutos revisados pelo operador; os checksums do repositório não cobrem esses overrides. As duas skills próprias são instaladas separadamente a partir do SHA da LUMI. Os locks fixam versões, não hashes dos wheels; reinstalação limpa ainda não homologada.
4. Revise o instalador oficial Ollama da versão 0.40.18 e seu checksum; confirme que ele instala a versão correta. Tags de modelos ainda não fixadas por digest.
5. Execute bash install.sh --dry-run. Configure memória (memory.md), LCD (lcd.md), então execute etapas com bash install.sh --only NOME ou --apply. Para retomar, após revisar o estado existente e backup, use ALLOW_EXISTING=yes em local.env. Não é mecanismo automático de rollback.
6. Faça logout/login após alteração de grupos; verifique acesso a framebuffer/input/audio. Calibração por unidade obrigatória. Não habilite comandos reais de energia.
7. Execute bash doctor.sh e docs/validation.md. Não considere sucesso de serviço equivalente a teste físico.

O script não altera fstab, boot config ou regra Polkit automaticamente; são ações deliberadas do operador. Não sobrescreva uma instalação ativa. Templates Systemd podem substituir unidades existentes apenas após autorização local explícita.

O provisionamento de áudio preserva config/audio.json existente e instala o template somente quando ausente. Valide os dispositivos pelo touchscreen; consulte [áudio](audio.md).
