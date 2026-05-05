#!/bin/bash
set -euo pipefail

su -c 'cat > /etc/apt/sources.list.d/alt.list <<'"'"'EOF'"'"'
# ftp.altlinux.org (ALT Linux, Moscow)

# ALT Linux Sisyphus
#rpm [alt] ftp://ftp.altlinux.org/pub/distributions/ALTLinux Sisyphus/x86_64 classic
#rpm [alt] ftp://ftp.altlinux.org/pub/distributions/ALTLinux Sisyphus/x86_64-i586 classic
#rpm [alt] ftp://ftp.altlinux.org/pub/distributions/ALTLinux Sisyphus/noarch classic

#rpm [alt] http://ftp.altlinux.org/pub/distributions/ALTLinux Sisyphus/x86_64 classic
#rpm [alt] http://ftp.altlinux.org/pub/distributions/ALTLinux Sisyphus/x86_64-i586 classic
#rpm [alt] http://ftp.altlinux.org/pub/distributions/ALTLinux Sisyphus/noarch classic

#rpm [alt] rsync://ftp.altlinux.org/ALTLinux Sisyphus/x86_64 classic
#rpm [alt] rsync://ftp.altlinux.org/ALTLinux Sisyphus/x86_64-i586 classic
#rpm [alt] rsync://ftp.altlinux.org/ALTLinux Sisyphus/noarch classic

#rpm [alt] https://download.basealt.ru/pub/distributions/ALTLinux Sisyphus/x86_64 classic
#rpm [alt] https://download.basealt.ru/pub/distributions/ALTLinux Sisyphus/x86_64-i586 classic
#rpm [alt] https://download.basealt.ru/pub/distributions/ALTLinux Sisyphus/noarch classic

#rpm [alt] https://mirror.truenetwork.ru/altlinux Sisyphus/x86_64 classic
#rpm [alt] https://mirror.truenetwork.ru/altlinux Sisyphus/x86_64-i586 classic
#rpm [alt] https://mirror.truenetwork.ru/altlinux Sisyphus/noarch classic

rpm [alt] http://mirror.mephi.ru/ALTLinux Sisyphus/x86_64 classic
rpm [alt] http://mirror.mephi.ru/ALTLinux Sisyphus/x86_64-i586 classic
rpm [alt] http://mirror.mephi.ru/ALTLinux Sisyphus/noarch classic


EOF'