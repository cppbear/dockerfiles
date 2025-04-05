FROM archlinux:base-devel

ARG USERNAME=arch

RUN sed -i 's/^#Color/Color/' /etc/pacman.conf \
    && pacman-key --init && pacman-key --populate archlinux \
    && pacman -Syy --noconfirm archlinux-keyring ca-certificates \
    && mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak \
    && echo 'Server = https://arch-archive.tuna.tsinghua.edu.cn/2024/03-04/$repo/os/$arch' > /etc/pacman.d/mirrorlist \
    && echo 'NoExtract = !usr/share/help/zh* !*locale*/zh*/* !usr/share/*locales/zh_??' >> /etc/pacman.conf \
    && pacman -Syyuu --noconfirm glibc \
    && sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen \
    && sed -i '/zh_CN.UTF-8/s/^#//g' /etc/locale.gen \
    && locale-gen \
    && pacman -Syy --noconfirm --needed \
    git cmake ninja llvm clang lld z3 \
    vim sudo pacman-contrib \
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    && pacman -Scc --noconfirm \
    && paccache -rk0 \
    && rm -rf /var/cache/pacman/pkg/* \
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
