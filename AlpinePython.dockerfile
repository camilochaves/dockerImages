FROM camilochaves/alpinebase
ARG USER="camilo"
ARG userPwd="123Camilo"
# Install python/pip
USER root
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 py3-pip 
RUN ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
USER $USER