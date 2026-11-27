# Homologação
Evidências do protótipo: UI v0.3.7 iniciou e navegou nas duas skills; RSS 48272 KiB (~47,14 MiB), 577 MiB disponíveis, CPU média acumulada 14% durante 55 s de testes. Inventário 605,81 ms. Mixer: 51,44 ms para três controles; alterações reais do volume, captura e AGC confirmadas. Consulta local Qwen anterior ~2,4 tokens/s; tempos variam com carregamento e prompt.
- [ ] Instalação limpa em cartão separado, sem intervenção não documentada.
- [ ] Driver, cores, calibração, navegação e brilho.
- [ ] Serviços ativos, bus loopback, Core pronto, identity determinística.
- [ ] Fallback local após fonte estável; medir latência e memória.
- [ ] Clima: alteração cidade, cache correto, falha offline, recuperação e limites de chamadas.
- [ ] ALSA: mixer, captura/reprodução física, persistência após shutdown.
- [ ] Skills: detalhes, atualização, paginação com mais de três itens.
- [ ] Simulação de energia, cancelamento em evento OVOS; regra Polkit reforçada e execução real somente depois de resolver fonte.
- [ ] Reboot, persistência, teste offline ponta a ponta e recuperação.
Pendências: start-limit-hit de weather.path sob chamadas repetidas, proteção global, atualização repetida do inventário, reconexão touch, timeout de parada Core, firewall efetivo, alimentação histórica 0x50000.
