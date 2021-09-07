FROM camilochaves/alpinepython:v1.0
ARG USER="camilo"
ARG userPwd="123Camilo"
USER root
RUN mkdir /var/lib/pgadmin && mkdir /var/log/pgadmin && chown $USER /var/lib/pgadmin && chown $USER /var/log/pgadmin
RUN pip install -U pip  
RUN pip install --pre psycopg
RUN python3 -m venv pgadmin4 && source pgadmin4/bin/activate 
RUN pip install pgadmin4




