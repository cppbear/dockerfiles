FROM archlinux:base-devel

ARG USERNAME=arch
ARG USEMIRROR=0

ENV TZ=Asia/Shanghai

COPY set-mirror.sh /usr/local/sbin/set-mirror

RUN sed -i 's/^#Color/Color/' /etc/pacman.conf \
    && echo 'NoExtract = !usr/share/help/zh* !*locale*/zh*/* !usr/share/*locales/zh_??' >> /etc/pacman.conf \
    && pacman-key --init && pacman-key --populate archlinux \
    && if [ "$USEMIRROR" = "1" ]; then \
        rm -rf /usr/local/sbin/set-mirror \
        && mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak \
        && echo 'Server = https://mirror.nju.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist \
        && echo '[archlinuxcn]' >> /etc/pacman.conf \
        && echo 'Server = https://mirror.nju.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf \
        && pacman -Syu --noconfirm archlinuxcn-keyring && pacman-key --populate archlinuxcn; \
    fi \
    # Set locale
    && pacman -Syu --noconfirm glibc \
    && sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen \
    && sed -i '/zh_CN.UTF-8/s/^#//g' /etc/locale.gen \
    && locale-gen \
    # Set timezone
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    # Install packages
    && pacman -Syu --noconfirm --needed \
    sudo pacman-contrib git \
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    && if [ "$USEMIRROR" = "1" ]; then \
    pacman -Syu --noconfirm --needed paru \
    && sed -i 's/^#BottomUp/BottomUp/' /etc/paru.conf; \
    fi \
    && pacman -Scc --noconfirm \
    && paccache -rk0 \
    && rm -rf /var/cache/pacman/pkg/* \
    # Set up user
    && useradd -m -G wheel $USERNAME -s /usr/bin/zsh \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -i 's/^ZSH_THEME=.*/ZSH_THEME="ys"/' ~/.zshrc \
    && sed -i 's/^# export LANG=.*/export LANG=zh_CN.UTF-8/' ~/.zshrc \
    && echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc \
    && echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

CMD ["/usr/bin/zsh"]
