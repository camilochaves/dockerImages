FROM ubuntu:latest as BASE
#https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends tini wget ca-certificates sudo locales fonts-liberation run-one \
    libxml2-utils xsltproc fop unixodbc unixodbc-dev curl build-essential autoconf libncurses5-dev openssl libssl-dev fop xsltproc git \
    libwxgtk3.0-gtk3-dev  libwxgtk-webview3.0-gtk3-dev default-jdk software-properties-common build-essential net-tools \
    python3 python3-pip python3-dev && \ 
    pip3 -q install pip --upgrade && \
    pip install jupyterlab  && \
    rm -rf /var/lib/apt/lists/* && \
    cd /$HOME && git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch release-v0.9.0 
RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.profile && echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc && \
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
ENV PATH="$PATH:/root/.asdf/bin"
RUN asdf update && asdf plugin-update --all && \
    asdf plugin-add erlang && asdf plugin-add elixir && \
    asdf install erlang 24.0.2 && asdf global erlang 24.0.2 && \
    asdf install elixir 1.12.1-otp-24 && asdf global elixir 1.12.1-otp-24
ENV PATH="$PATH:/root/.asdf/installs/elixir/1.12.1-otp-24/bin:/root/.asdf/installs/erlang/24.0.2/bin:/root/.mix/archives/hex-0.21.2/hex-0.21.2"
RUN mix local.hex --force
RUN cd /root && \
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    cd /root && \
    apt-get install -y dotnet-sdk-5.0 && \
    dotnet tool install -g --add-source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json" Microsoft.dotnet-interactive
ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet interactive jupyter install


#CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
#after entering the container 
#jupyter-lab --ip 0.0.0.0 --no-browser --allow-root

WORKDIR /Jupyter
EXPOSE 8888

