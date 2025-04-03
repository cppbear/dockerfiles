FROM archlinux:base-devel

RUN echo 'Server = https://mirror.nju.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
    echo '[archlinuxcn]' >> /etc/pacman.conf && \
    echo 'Server = https://mirrors.cernet.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf

RUN pacman-key --init && pacman-key --populate \
    && pacman -Syu --noconfirm archlinuxcn-keyring && pacman-key --populate archlinuxcn \
    && pacman -Syu --noconfirm --needed \
    git cmake ninja vim sudo paru pacman-contrib \
    && pacman -Scc --noconfirm \
    && paccache -rk0 \
    && rm -rf /var/cache/pacman/pkg/*

RUN useradd -m -G wheel arch && \
    echo "arch ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER arch
WORKDIR /home/arch

CMD ["/bin/bash"]
