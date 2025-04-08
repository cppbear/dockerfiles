FROM debian:latest

ARG USERNAME=debian
ARG DEBIAN_FRONTEND=noninteractive
ARG USEMIRROR=0

ENV TZ=Asia/Shanghai

COPY set-mirror.sh /usr/local/sbin/set-mirror

RUN if [ "$USEMIRROR" = "1" ]; then \
        rm -rf /usr/local/sbin/set-mirror \
        && sed -i.bak '/http:\/\/deb\.debian\.org\/debian$/s||http://mirror.nju.edu.cn/debian|' /etc/apt/sources.list.d/debian.sources; \
    fi \
    && apt update -y && apt upgrade -y \
    && apt install -y ca-certificates \
    && if [ "$USEMIRROR" = "1" ]; then \
    sed -i 's|http://mirror.nju.edu.cn|https://mirror.nju.edu.cn|g' /etc/apt/sources.list.d/debian.sources; \
    fi \
    # Set locale
    && apt install -y locales \
    && sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen \
    && sed -i '/zh_CN.UTF-8/s/^#//g' /etc/locale.gen \
    && locale-gen \
    # Set timezone
    && apt install -y tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    # Install packages
    && apt install -y build-essential git curl wget \
    sudo lsb-release \
    zsh zsh-autosuggestions zsh-syntax-highlighting \
    && rm -rf /var/lib/apt/lists/* \
    # Set up user
    && useradd -m -s /usr/bin/zsh -G sudo "$USERNAME" \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -i 's/^ZSH_THEME=.*/ZSH_THEME="ys"/' ~/.zshrc \
    && sed -i 's/^# export LANG=.*/export LANG=zh_CN.UTF-8/' ~/.zshrc \
    && echo 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc \
    && echo 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

CMD ["/usr/bin/zsh"]
