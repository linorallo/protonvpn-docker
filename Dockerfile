FROM archlinux:latest

# install required packages
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xvf "$patched_glibc"
RUN mkdir -p /opt/arch/var/lib/pacman && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm which expect openvpn dialog python-pip python-setuptools git dante && \
    pip install protonvpn-cli

COPY ./vpn-setup.exp ./config.sh /tmp/

# protonvpn-cli needs access to width
ENV COLUMNS 80

RUN source /tmp/config.sh && \
    expect /tmp/vpn-setup.exp && \
    rm /tmp/vpn-setup.exp /tmp/config.sh
    
COPY ./sockd.conf /etc/
