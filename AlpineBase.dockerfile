FROM alpine:latest
ARG userName="camilo"
ARG rootPwd="123Alpine"
ARG userPwd="123Camilo"
ENTRYPOINT ["zsh"]
#Configure bash to display hostsname, user and directory using PS1 Environment variable 
#ENV PS1="\[\033[0;31m\]\u@\h:\[\033[36m\]\W\[\033[0m\]"
USER root
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/releases" >> /etc/apk/repositories && \    
    apk upgrade && \
    echo -e "${rootPwd}\n${rootPwd}" | passwd && \
    apk add --no-cache sed attr dialog grep util-linux pciutils usbutils binutils findutils readline lsof less nano \ 
    curl git sudo zip unzip cmake make musl-dev gcc gettext-dev libintl ip6tables ufw && \
    echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel && \
    echo -e "${userPwd}\n${userPwd}" | adduser ${userName} && adduser ${userName} wheel && \
    apk add --virtual .asdf-deps --no-cache && \
    git clone --depth 1 https://github.com/asdf-vm/asdf.git /root/.asdf --branch release-v0.9.0  && \
    chmod +x /root/.asdf/asdf.sh && \
    echo -e '\n. /root/.asdf/asdf.sh' >> /root/.bashrc && \
    echo -e '\n. /root/.asdf/asdf.sh' >> /root/.profile 
ENV PATH="${PATH}:/root/.asdf/bin:/root/.asdf"
RUN apk add zsh && \
    sed -i "s/\/bin\/ash/\/bin\/zsh/g" /etc/passwd && \
    cd /root/ && wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install.sh && \
    zsh /root/install.sh && \
    sed -i "s/robbyrussell/fino/g" /root/.zshrc && zsh /root/.zshrc

RUN wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip && \
    unzip musl-locales-master.zip && \
    cd musl-locales-master && \
    cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install && \
    cd .. && rm -r musl-locales-master

USER ${userName}
WORKDIR /home/${userName}
RUN wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install.sh 
RUN zsh $HOME/install.sh && \
    sed -i "s/robbyrussell/intheloop/g" $HOME/.zshrc && zsh $HOME/.zshrc && rm -f install.sh 
ENV SHELL=/bin/zsh \
    MUSL_LOCPATH=/usr/share/i18n/locales/musl \
    LANG=pt_BR.UTF-8 \
    LANGUAGE=pt_BR.UTF-8







