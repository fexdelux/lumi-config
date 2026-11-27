# LCD e touchscreen
Fork fexdelux/LCD-show, branch feature/lumi-project; obtenha o SHA real do protótipo com git -C ~/LCD-show rev-parse HEAD. Driver tft35a, rotate=90, SPI, 480×320, RGB565, stride 960; o LCD pode ser fb0 ou fb1 conforme HDMI. Identifique pelo nome fb_ili9486 em /sys/class/graphics/fb*/name.
Leia a documentação e --help do commit fixado. Use LCD35-lite-show, LCD35-lite-status e mecanismo de recuperação do fork. Faça backup de /boot/firmware/config.txt; não copie configuração integral de outra máquina. Reinicie somente com alimentação estável.
Calibre no próprio dispositivo: python3 ~/LCD-show/lumi-lcd/demo.py --fb /dev/fbN --rotate 90 --calibration ~/lumi-touch.json --calibrate. Substitua fbN pelo dispositivo encontrado. Verifique cinco pontos, cores e orientação. Não publique a matriz individual. Brilho implementado por transformação de pixels, não por controle de backlight; não implica economia elétrica.

A preparação do framebuffer para boot sem HDMI (serviço lumi-display-prepare e script local) foi homologada no protótipo, mas ainda precisa ser incorporada ao provisionamento. Não considere a instalação headless automática concluída.
