# Добавление фонового автообновления по крону в 12.00 + 22.00 + автоочистка в фоне по субботам в 11.30 с выводом лога на рабочий стол
#!/bin/bash
set -e
# Заменить путь, чтобы не было ошибок
LOGFILE="/home/als/Рабочий стол/alt_log.log"
TEMP_CRONFILE="/tmp/temp_crontab.txt"

# Создать файл лога, если он не существует
touch "$LOGFILE"

# Переменные обновлений, путь нужно поправить для своего пользователя
CRON_DAILY_UPDATE='0 12 * * * root epm update && epm full-upgrade -y >> "/home/als/Рабочий стол/alt_log.log" 2>&1'
CRON_NIGHTLY_UPDATE='0 22 * * * root epm update && epm full-upgrade -y >> "/home/als/Рабочий стол/alt_log.log" 2>&1'
CRON_CLEAN_CACHE='30 11 * * 6 root apt-get clean && apt-get autoclean && apt-get check && flatpak uninstall --unused -y && journalctl --vacuum-time=1weeks >> "/home/als/Рабочий стол/alt_log.log" 2>&1'

# Создать временный файл crontab
echo "Создаём временный файл crontab..." | tee -a "$LOGFILE"
{
    echo "$CRON_DAILY_UPDATE"
    echo "$CRON_NIGHTLY_UPDATE"
    echo "$CRON_CLEAN_CACHE"
} > "$TEMP_CRONFILE"

# Вывод временного файла в crontab
echo "Обновляем системный crontab. Пожалуйста, введите пароль root." | tee -a "$LOGFILE"
su -c "cat $TEMP_CRONFILE >> /etc/crontab"

# Удаление временного файла
rm "$TEMP_CRONFILE"

echo "Готово! Правила добавлены в системный crontab." | tee -a "$LOGFILE"
