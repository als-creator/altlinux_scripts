#!/bin/bash
# Скрипт для настройки по крону автообновления 2 раза в день и автоочистки по субботам
set -e

# Сохранить имя пользователя ДО su (на ALT нет sudo — только su -)
if [ "$EUID" -ne 0 ]; then
    CURRENT_USER=$(whoami)
    echo "Текущий пользователь: $CURRENT_USER"
    echo "Требуются права root. Запускаем как root через su - (пароль один раз)."
    exec su -c "CURRENT_USER=$CURRENT_USER sh '$0' $*"
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

# Установка скрипта субботней очистки (содержимое cc из конфигов шеллов)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/clean_system.sh" ]; then
    install -m 755 "$SCRIPT_DIR/clean_system.sh" /usr/local/bin/clean_system.sh
    echo "Установлен /usr/local/bin/clean_system.sh" | tee -a "$LOGFILE"
else
    echo "Предупреждение: не найден clean_system.sh рядом со скриптом" | tee -a "$LOGFILE"
fi

# Cron задания
CRON_DAILY_UPDATE="0 12 * * * root epm update && epm full-upgrade -y >> \"$LOGFILE\" 2>&1"
CRON_NIGHTLY_UPDATE="0 22 * * * root epm update && epm full-upgrade -y >> \"$LOGFILE\" 2>&1"
CRON_CLEAN_CACHE="30 11 * * 6 root /usr/local/bin/clean_system.sh >> \"$LOGFILE\" 2>&1"

# Убираем старые записи update и очистки, чтобы не было дублей в /etc/crontab
sed -i -e '/^0 12 \* \* \* root/d' -e '/^0 22 \* \* \* root/d' -e '/^30 11 \* \* 6 root/d' /etc/crontab 2>/dev/null || true

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
