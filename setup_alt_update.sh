# Скрипт для настройки по крону автообновления 2 раза в день и автоочистки по субботам
#!/bin/bash
set -e

# Сохранить имя пользователя ДО su
if [ "$EUID" -ne 0 ]; then
    CURRENT_USER=$(whoami)
    echo "Текущий пользователь: $CURRENT_USER"
    echo "Требуются права root. Запускаем как root (пароль один раз)."
    exec su -c "CURRENT_USER=$CURRENT_USER $0 $*"
fi

# Root режим
CURRENT_USER="${CURRENT_USER:-als}"
USER_HOME="/home/$CURRENT_USER"

# Проверка папки Desktop
if [ -d "$USER_HOME/Desktop" ]; then
    DESKTOP_DIR="$USER_HOME/Desktop"
elif [ -d "$USER_HOME/Рабочий стол" ]; then
    DESKTOP_DIR="$USER_HOME/Рабочий стол"
else
    echo "Ошибка: не найдена папка Desktop или Рабочий стол в $USER_HOME!"
    exit 1
fi

LOGFILE="$DESKTOP_DIR/alt_log.log"
TEMP_CRONFILE="/tmp/temp_crontab_$$.txt"

echo "Домашняя директория: $USER_HOME"
echo "Лог: $LOGFILE"

# Права лог-файла
touch "$LOGFILE"
chmod 666 "$LOGFILE"

# Cron задания
CRON_DAILY_UPDATE="0 12 * * * root epm update && epm full-upgrade -y >> \"$LOGFILE\" 2>&1"
CRON_NIGHTLY_UPDATE="0 22 * * * root epm update && epm full-upgrade -y >> \"$LOGFILE\" 2>&1"
CRON_CLEAN_CACHE="30 11 * * 6 root apt-get clean && apt-get autoclean && apt-get autoremove -y && flatpak uninstall --unused -y && journalctl --vacuum-time=1w >> \"$LOGFILE\" 2>&1"

# Создать временный файл
{
    echo "$CRON_DAILY_UPDATE"
    echo "$CRON_NIGHTLY_UPDATE"
    echo "$CRON_CLEAN_CACHE"
} > "$TEMP_CRONFILE"

echo "Cron задания:"
cat "$TEMP_CRONFILE"

# Выполнить root команды
echo "Обновляем /etc/crontab..." | tee -a "$LOGFILE"
cat "$TEMP_CRONFILE" >> /etc/crontab
rm -f "$TEMP_CRONFILE"

echo "Готово! Правила добавлены." | tee -a "$LOGFILE"
echo "Расписание:" | tee -a "$LOGFILE"
echo "   • 12:00 - epm update/full-upgrade" | tee -a "$LOGFILE"
echo "   • 22:00 - epm update/full-upgrade" | tee -a "$LOGFILE"
echo "   • Сб 11:30 - очистка" | tee -a "$LOGFILE"

echo "/etc/crontab (конец):"
tail -5 /etc/crontab

echo "Лог: $(ls -la "$LOGFILE")" | tee -a "$LOGFILE"
echo "Тест записи: $(date)" >> "$LOGFILE"
