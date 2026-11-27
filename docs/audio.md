# Áudio — Dynamic Audio (LUMI 0.3.8)

ALSA direto, sem PulseAudio/PipeWire obrigatório. O instalador copia o template `templates/display/audio.json` somente se não existir `~/lumi/config/audio.json`. Entrada automática (somente quando há um dispositivo elegível); saída manual Headphones, device 0. A seleção manual é preservada durante desconexão e não recorre silenciosamente a outro dispositivo. Configure pelo touchscreen. IDs ALSA podem variar em hardware diferente; dispositivos idênticos ainda não têm identificação física persistente.

## Diagnóstico

- `aplay -l`, `arecord -l`, `cat /proc/asound/pcm` e `bash doctor.sh`.
- Volume, ganho, mute e AGC dependem das capacidades do mixer. Não assuma nome de controle ou placa USB fixos.
- Teste de alto-falante e gravação de cinco segundos com reprodução, pico, RMS e saturação; captura PCM 16 bits mono 16 kHz. Reduza volume antes de ouvir; 100% no P2 chegou a +4 dB.
- Monitor UDEV integrado ao Display, debounce de 500 ms e recuperação automática; não precisa de serviço separado nem pyudev. P2 analógico não necessariamente gera evento de hot-plug.
- Configuração inválida é preservada; corrija o JSON após backup. Não substitua automaticamente preferências do usuário.
- ALSA restore pode preservar mixer no shutdown normal; persistência após reboot ainda requer validação. Não crie daemon adicional.

## Validação e limites

No protótipo Pi 3, microfone USB UACDemoV10 e saída Headphones homologados, inclusive 16/48 kHz, seleção, hot-plug, cancelamento e recuperação real do monitor. 39 testes automatizados e 11 verificações finais aprovados. Instalação limpa ainda não homologada. Bluetooth, medição de amplitude em tempo real e coordenação exclusiva STT/TTS pendentes.
