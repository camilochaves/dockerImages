FROM camilochaves/alpinepython:v1.0
ARG userName="postgres"
ARG userPwd="123postgres"
ARG postgresUser="camilodb"
ARG postgresPwd="123camilodb"
ARG postgresDb="demo"
ARG PORTS="5432 5050"
ENV PORT=$PORTS \
    POSTGRES_USER=${postgresUser} \
    POSTGRES_PASSWORD=${postgresPwd} \
    POSTGRES_DB=${postgresDb}
EXPOSE $PORT
USER root
RUN echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel && \
    echo -e "${userPwd}\n${userPwd}" | adduser ${userName} && \
    adduser ${userName} wheel 
USER ${userName}
WORKDIR /home/${userName}
RUN wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install.sh && \
    zsh $HOME/install.sh && \
    sed -i "s/robbyrussell/intheloop/g" $HOME/.zshrc && zsh $HOME/.zshrc && rm -f install.sh 

USER root
RUN apk add postgresql && \
     #PostgreSQL requires a directory path for create and store its .s.PGSQL.5432 socket.
    mkdir /run/postgresql && \
    chown postgres:postgres /run/postgresql 
RUN echo "rc_verbose=yes" > /etc/conf.d/local
RUN mkdir /var/lib/postgresql/data && \
    chown postgres:postgres /var/lib/postgresql/data && \
    chmod 0700 /var/lib/postgresql/data && \
    su postgres -c "initdb -D /var/lib/postgresql/data"
RUN touch /etc/init.d/postgres-custom.start && \
    echo "#!/bin/zsh" >> /etc/init.d/postgres-custom.start && \
    echo "pg_ctl start -D /var/lib/postgresql/data -l logfile" >> /etc/init.d/postgres-custom.start && \
    echo "psql -U postgres -c \"CREATE USER ${postgresUser} CREATEDB ENCRYPTED PASSWORD '${postgresPwd}'; \" " >> /etc/init.d/postgres-custom.start && \
    echo "psql -U postgres -c \"CREATE DATABASE ${postgresDb} OWNER ${postgresUser}; \" " >> /etc/init.d/postgres-custom.start && \
    echo "zsh" >> /etc/init.d/postgres-custom.start && \
    chmod +x /etc/init.d/postgres-custom.start && \
    echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/data/pg_hba.conf && \
    echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf 
    #apk add openrc && \
    #rc-update add local default && \
    #openrc

USER ${userName}
ENV SHELL="/bin/zsh"
CMD ["/etc/init.d/postgres-custom.start"]








  

    


