# Arquitetura LUMI Genesis
Baseline de 26/11/2026: Raspberry Pi 3 Model B Rev 1.2, Cortex-A53 ARM64, 904 MiB úteis, Debian 13 Lite. Sem X11, Wayland, Docker, GPU ou computador externo obrigatório.

UI Python 3.13/Pillow → framebuffer SPI ILI9486 RGB565 480×320 (/dev/fb1), toque ADS7846 via evdev. MessageBus local 127.0.0.1:8181 em venv separado. Core Python 3.12.16 → Identity Skill determinística e Fallback Skill → Ollama 127.0.0.1:11434. Qwen2.5 0.5B e SmolLM2 135M. SQLite local para catálogo de municípios; Open-Meteo opcional, cache validado por identidade geográfica. ALSA direto, sem servidor de som.

UI v0.3.7: Home, Tela, Clima, Rede, Áudio, Sistema, Apps e Skills. Providers, controladores e renderizadores separados. Estado de voz via bus. Inventário via metadados de entry points, não prova de carregamento das skills.

STT, TTS e wake word ainda não implementados. VPS somente extensão opcional futura.
