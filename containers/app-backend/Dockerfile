FROM python:3.12.0-alpine3.17@sha256:fc34b07ec97a4f288bc17083d288374a803dd59800399c76b977016c9fe5b8f2 as build

ENV XMRIG_VERSION="6.20.0"

# xmrig
RUN set -eux && \
    # ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), static-pie linked, stripped
    mkdir -p /mnt/xmrig && \
    wget -q "https://github.com/xmrig/xmrig/releases/download/v${XMRIG_VERSION}/xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz" -O /mnt/xmrig/xmrig-linux-static-x64.tar.gz && \
    tar xvzf /mnt/xmrig/xmrig-linux-static-x64.tar.gz -C /mnt/xmrig/ --strip-components=1 "xmrig-${XMRIG_VERSION}/xmrig"

# Compile own version of xmrig cryptominer
RUN set -eux && \
    if [ "$(uname -m)" = "x86_64" ]; then \
      apk add --no-cache git make cmake libstdc++ gcc g++ libuv-dev openssl-dev hwloc-dev && \
      git clone --branch "v${XMRIG_VERSION}" https://github.com/xmrig/xmrig && \
      sed -i \
        -e 's/APP_ID.*/APP_ID "myxmrig"/' \
        -e 's/APP_NAME.*/APP_NAME "My XMRig"/' \
        -e 's/APP_DESC.*/APP_DESC "My XMRig miner"/' \
        -e 's/APP_VERSION.*"\(.*\)"/APP_VERSION "\1-my"/' \
        xmrig/src/version.h && \
      cmake -S xmrig -B xmrig/build && make -C xmrig/build -j"$(nproc)" && \
      ./xmrig/build/xmrig --version && \
      mv ./xmrig/build/xmrig /mnt/xmrig/my-xmrig ; \
    fi

# eicar
# RUN set -eux && \
#     # EICAR virus test files
#     mkdir -p /mnt/eicar && \
#     wget -q -P /mnt/eicar https://secure.eicar.org/eicar.com https://secure.eicar.org/eicar.com.txt https://secure.eicar.org/eicarcom2.zip

# linux malware + ransomware for different architectures
RUN set -eux && \
    # ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, with debug_info, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Linux.Trojan.Multiverze/0a5a7008fa1a17c8ee32ea4e2f7e25d7302f9dfc4201c16d793a1d03f95b9fa5.elf.x86" -O /mnt/Linux.Trojan.Multiverze.elf.x86 && \
    # ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/40e8d9d82800728a5f1cfc2c2e156d5ee72fb44c54c26a86cfd35e95ea737e37.elf.x86_64"    -O /mnt/Unix.Trojan.Mirai.elf.x86_64 && \
    # POSIX shell script, ASCII text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Downloader.Rocke/228ec858509a928b21e88d582cb5cfaabc03f72d30f2179ef6fb232b6abdce97.sh"        -O /mnt/Unix.Downloader.Rocke.sh && \
    # Bourne-Again shell script, ASCII text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Txt.Malware.Sustes/0e77291955664d2c25d5bfe617cec12a388e5389f82dee5ae4fd5c5d1f1bdefe.sh"           -O /mnt/Txt.Malware.Sustes.sh && \
    # Perl script text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Win.Trojan.Perl/9aed7ab8806a90aa9fac070fbf788466c6da3d87deba92a25ac4dd1d63ce4c44.perl"            -O /mnt/Win.Trojan.Perl.perl && \
    # Python script, ASCII text executable, with very long lines (4330), with CRLF line terminators
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Py.Trojan.NecroBot/0e600095a3c955310d27c08f98a012720caff698fe24303d7e0dcb4c5e766322.py"           -O /mnt/Py.Trojan.NecroBot.py && \
    # Java archive data (JAR)
    wget -q "https://github.com/HonbraDev/fractureiser-samples/raw/221bcc4bf45d5896f8908b21d5a8f3e7fcbc2875/stage-0-infected-DisplayEntityEditor-1.0.4.jar"                                                                -O /mnt/Trojan.Java.Fractureiser.MTB.jar

RUN set -eux && \
    # Bug with versions: https://github.com/joeyespo/grip/issues/377
    # renovate: datasource=pypi depName=grip
    GRIP_VERSION="4.6.2" && \
    pip install --no-cache-dir grip=="${GRIP_VERSION}" flask==2.3.3 werkzeug==2.3.7 


################################################################################

FROM nginxinc/nginx-unprivileged:1.25.5-alpine-slim@sha256:f6909c9b5cf8e46f72004f38aafa7483d7cb13375ad050d6be7f27989d085bd3

COPY --from=build /mnt/ /usr/share/nginx/html/

RUN printf '%s\n' > /etc/nginx/conf.d/health.conf \
    'server {' \
    '    listen 8081;' \
    '    location / {' \
    '        access_log off;' \
    '        add_header Content-Type text/plain;' \
    '        return 200 "healthy\n";' \
    '    }' \
    '}'

USER nginx

# Healthcheck to make sure container is ready 
HEALTHCHECK --interval=5m --timeout=3s CMD curl --fail http://localhost:8081 || exit 1