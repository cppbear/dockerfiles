FROM archlinux:base-devel

ARG USERNAME=arch

RUN echo 'Server = https://mirror.nju.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist \
    && sed -i 's/^#Color/Color/' /etc/pacman.conf \
    && echo 'NoExtract = !usr/share/help/zh* !*locale*/zh*/* !usr/share/*locales/zh_??' >> /etc/pacman.conf \
    && echo '[archlinuxcn]' >> /etc/pacman.conf \
    && echo 'Server = https://mirror.nju.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf \
    && pacman-key --init && pacman-key --populate archlinux \
    && pacman -Syu --noconfirm archlinuxcn-keyring && pacman-key --populate archlinuxcn \
    && pacman -Syu --noconfirm glibc \
    && sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen \
    && sed -i '/zh_CN.UTF-8/s/^#//g' /etc/locale.gen \
    && locale-gen \
    && pacman -Syu --noconfirm --needed \
    sudo paru pacman-contrib \
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    && pacman -Scc --noconfirm \
    && paccache -rk0 \
    && rm -rf /var/cache/pacman/pkg/* \
    && sed -i 's/^#BottomUp/BottomUp/' /etc/paru.conf \
    && useradd -m -G wheel $USERNAME -s /usr/bin/zsh \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -i 's/^ZSH_THEME=.*/ZSH_THEME="ys"/' ~/.zshrc \
    && sed -i 's/^# export LANG=.*/export LANG=zh_CN.UTF-8/' ~/.zshrc \
    && echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc \
    && echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

CMD ["/usr/bin/zsh"]
