#!/bin/bash
# Пост‑инсталляционный скрипт для Alt Linux
# Последовательно:
# 1) включаем sudo через control для группы wheel
# 2) добавляем в /etc/fstab разделы LABEL=Data и LABEL=Work
# 3) выполняем обновление системы через apt-get
# 4) устанавливаем основной набор пакетов через apt-get
# 5) обновляем систему через epm (update + full-upgrade + autoremove)
# 6) устанавливаем дополнительные пакеты через epm play


set -euo pipefail

echo "=== 1) Включаем sudo для группы wheel через control ==="

su -c 'control sudowheel enabled' -l
su -c 'control sudo' -l

echo "Sudo включён для группы wheel. Проверка политики выполнена."

echo "=== 2) Добавляем диски по LABEL в /etc/fstab (без дублирования) ==="

fstab="/etc/fstab"

# Создаём точки монтирования
mkdir -p /run/media/als/Data
mkdir -p /run/media/als/Work

# Проверяем, что строки с LABEL=Data и LABEL=Work ещё не присутствуют
if ! grep -q '^[[:space:]]*LABEL=Data' "$fstab"; then
    echo "LABEL=Data  /run/media/als/Data  auto  nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Data  0 0" >> "$fstab"
    echo "Добавлена запись в fstab: LABEL=Data"
else
    echo "Запись для LABEL=Data уже есть в fstab, не дублируем."
fi

if ! grep -q '^[[:space:]]*LABEL=Work' "$fstab"; then
    echo "LABEL=Work  /run/media/als/Work  auto  nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Work  0 0" >> "$fstab"
    echo "Добавлена запись в fstab: LABEL=Work"
else
    echo "Запись для LABEL=Work уже есть в fstab, не дублируем."
fi

echo "fstab: диски Data и Work добавлены (по LABEL), дублирование отсутствует."

echo "=== 3) Полное обновление системы через apt-get ==="

echo "Обновление кэша репозиториев..."
su -c 'apt-get update' -l

echo "Полное обновление системы (dist-upgrade)..."
su -c 'apt-get dist-upgrade -y' -l

echo "Очистка кэша пакетов apt-get..."
su -c 'apt-get clean' -l

echo "Система обновлена через apt-get."

echo "=== 4) Установка основных пакетов через apt-get ==="

su -c 'apt-get install -y \
    ncdu \
    guake \
    zram-generator \
    micro \
    neovim \
    ranger \
    mc \
    fastfetch \
    fish \
    git \
    lazygit \
    uv \
    direnv \
    mtr \
    bat \
    lsd \
    fd \
    ripgrep \
    eza \
    fzf \
    zoxide \
    nikto \
    aircrack-ng \
    zenmap \
    nmap \
    wireshark-qt \
    putty \
    filezilla \
    whois \
    codium \
    yandex-browser-stable \
    rustdesk \
    qmmp \
    smplayer \
    smplayer-skins \
    smplayer-themes \
    gvfs \
    ffmpegthumbnailer \
    gearlever \
    obs-studio \
    wgetpaste \
    xclip \
    yt-dlp \
    deno \
    pyradio \
    radiotray-ng \
    galculator \
    gnome-disk-utility \
    kdiskmark \
    qdiskinfo \
    qbittorrent \
    virtualbox \
    steam \
    alt-gaming \
    handbrake-gtk \
    flameshot \
    kdenlive \
    kate \
    konsole \
    kdeconnect \
    aichat \
    qimgv \
    qpdfview \
    blueman \
    conky \
    gnome-disk-usage \
    gnome-themes-standard \
    icon-theme-kora-pgrey \
    xfce4-weather-plugin \
    xfce4-notification-plugin \
    xfce4-clipman-plugin \
    vcmi \
    grub-customizer \
    fonts-ttf-jetbrains-mono-nl \
    fonts-ttf-fira-code-nerd' -l

echo "Основные пакеты установлены через apt-get."

echo "=== 5) Обновление через epm (update + full-upgrade + autoremove) ==="

su -c 'epm update' -l
su -c 'epm full-upgrade -y' -l
su -c 'epm autoremove -y' -l

echo "Система обновлена через epm (update + full-upgrade + autoremove)."

echo "=== 6) Установка дополнительных пакетов через epm play ==="

su -c 'epm play anydesk assistant rudesktop localsend obsidian' -l

echo "Дополнительные пакеты установлены через epm play."

echo "=== Пост‑инсталляционный скрипт для Alt Linux завершён ==="
