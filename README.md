# LUMI Config

Provisionamento da LUMI Genesis para Raspberry Pi 3, Debian 13 ARM64 / Raspberry Pi OS Lite. Aplicação: https://github.com/fexdelux/lumi. Driver: https://github.com/fexdelux/LCD-show.

## Estado
Baseline experimental da UI v0.3.7. Componentes homologados individualmente no protótipo; instalação limpa ainda não homologada. Não é uma imagem de sistema nem uma release estável.

## Uso
Clone este repositório e execute `bash install.sh --dry-run` para conhecer o plano. Execute `bash doctor.sh` para diagnóstico. Consulte [instalação](docs/installation.md), [arquitetura](docs/architecture.md) e [validação](docs/validation.md). O instalador exige referências e dependências verificadas antes de provisionar. Não execute no dispositivo de produção sem backup.

Processamento de IA local, sem computador externo obrigatório. Meteorologia é opcional e usa Internet. STT, TTS e wake word ainda não fazem parte da baseline. Reinício/desligamento pela UI permanecem em simulação.

Não versionar credenciais, calibração individual, configurações de rede, logs ou modelos binários.
