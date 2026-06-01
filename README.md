# altlinux_scripts  

autoinstall_byedpi_altlinux.sh  
Настраивает из сизифа byedpi по адресу 127.0.0.1:14228 socks5  
Поменять настройки можно в /etc/sysconfig/byedpi  
Для настройки прокси браузера можно использовать расширения FoxyProxy, SmartProxy или Proxy SwitchyOmega.

setup_alt_update.sh  
Добавляет в планировщик задание для фонового обновления системы каждый день в 12:00 и в 22:00  
Добавляет автоочистку системы в фоне в субботу в 11:30  

altlinux_postinstall_script.sh  
Включает sudo, делает полное обновление системы, прописывает монтирование дисков в /etc/fstab по LABEL, ставил набор пакетов из реп альта и epm.
Диски монтируются мои, если у вас таких дисков не существует, то после ребута система не загрузится, не забывайте редактировать скрипт под свои нужды.

autoinstall_yggdrasil_altlinux.sh  
Автонастройка yggdrasil из реп, добавление пиров для .

update_sisyphus_mirrors.sh  
Перезаписывает стандартный лист с репами от altlinux.ru, добавляя для сизифа репы mirror.mephi.ru + download.basealt.ru + mirror.truenetwork.ru
По дефолту раскомментированы mirror.mephi.ru
