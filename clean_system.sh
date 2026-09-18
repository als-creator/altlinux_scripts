#!/bin/bash
# ============================================================
# Очистка системы — содержимое cc (~/.bashrc, ~/.zshrc, config.fish)
# Запускается по cron: 30 11 * * 6 root /usr/local/bin/clean_system.sh
# ============================================================

# pacman (Arch) / apt-get (Debian, ALT Linux)
if command -v pacman >/dev/null 2>&1; then
    pacman -Sc --noconfirm

    # Сироты (только если есть, без подтверждений)
    orphans="$(pacman -Qdtq 2>/dev/null)"
    if [ -n "$orphans" ]; then
        # shellcheck disable=SC2086
        pacman -Rsn --noconfirm $orphans
    fi

    # Временные каталоги загрузки pacman
    if [ -d /var/cache/pacman/pkg/ ]; then
        find /var/cache/pacman/pkg/ -mindepth 1 -maxdepth 1 -type d -name 'download-*' -print -exec rm -rf -- {} +
    fi

    # Кэш yandex-browser реального пользователя (не root)
    user_home="$(getent passwd | awk -F: '$3 >= 1000 { print $6; exit }')"
    [ -n "$user_home" ] && rm -rf "$user_home/.cache/yandex-browser"
elif command -v apt-get >/dev/null 2>&1; then
    apt-get clean
    apt-get autoclean
    apt-get check
else
    echo "Не найден подходящий пакетный менеджер (pacman/apt-get)"
    exit 1
fi

# Очистка неиспользуемых Flatpak (необязательный шаг — не должен ломать скрипт)
if command -v flatpak >/dev/null 2>&1; then
    flatpak uninstall --unused -y 2>/dev/null || true
fi

# Старые журналы systemd (необязательный шаг)
if command -v journalctl >/dev/null 2>&1; then
    journalctl --vacuum-time=1w 2>/dev/null || true
fi

exit 0