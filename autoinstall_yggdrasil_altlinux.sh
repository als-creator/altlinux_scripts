#!/bin/bash

set -euo pipefail

# Установка
su -c 'epm install yggdrasil' -l

# Генерация базового конфига
su -c 'yggdrasil -genconf > /etc/yggdrasil.conf' -l

echo "Добавление публичных пиеров из Europe/Russia..."

URL="https://raw.githubusercontent.com/yggdrasil-network/public-peers/refs/heads/master/europe/russia.md"

# Исправленный парсер
PEERS=$(curl -sL "$URL" | \
    grep -Eo '(tcp|tls|quic|ws|wss|socks)://[^[:space:]<>`|*]*' | \
    awk '{gsub(/"/, ""); print "  \""$0"\","}')

if [ -z "$PEERS" ]; then
    echo "Не удалось извлечь пиры из $URL" >&2
    exit 1
fi

TMP_CONF="/tmp/yggdrasil.conf.tmp"

# Вставка в Peers
sudo awk -v p="$PEERS" '
/^[[:space:]]*Peers:[[:space:]]*\[.*\]/ {
    sub(/\[.*\]/, "[\n" p "\n]")
    print
    next
}
/^[[:space:]]*Peers:[[:space:]]*\[/ {
    print
    in_peers = 1
    next
}
in_peers {
    if (/\]/) {
        print
        in_peers = 0
    }
    next
}
{ print }
' /etc/yggdrasil.conf > "$TMP_CONF"

sudo mv "$TMP_CONF" /etc/yggdrasil.conf

echo "Peers для России добавлены в /etc/yggdrasil.conf."
su -c 'systemctl enable --now yggdrasil' -l
