FROM fedora:latest

ARG USERNAME=fedora
ARG USEMIRROR=0

ENV TZ=Asia/Shanghai

COPY set-mirror.sh /usr/local/sbin/set-mirror

RUN if [ "$USEMIRROR" = "1" ]; then \
        rm -rf /usr/local/sbin/set-mirror \
        && sed -e 's|^metalink=|#metalink=|g' \
        -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirror.nju.edu.cn/fedora|g' \
        -i.bak \
        /etc/yum.repos.d/fedora.repo \
        /etc/yum.repos.d/fedora-updates.repo; \
    fi \
    && dnf makecache && dnf upgrade -y \
    # Set locale
    && dnf install -y glibc-langpack-zh glibc-langpack-en \
    # Set timezone
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    # Install packages
    && dnf install -y @development-tools git wget \
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    && dnf clean all \
    # Set up user
    && useradd -m -s /usr/bin/zsh -G wheel "$USERNAME" \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -i 's/^ZSH_THEME=.*/ZSH_THEME="ys"/' ~/.zshrc \
    && sed -i 's/^# export LANG=.*/export LANG=zh_CN.UTF-8/' ~/.zshrc \
    && echo 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc \
    && echo 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

CMD ["/usr/bin/zsh"]
