FROM camilochaves/alpinepython:v1.0
ARG userName="camilo"
ARG userPwd="123Camilo"
ARG PORTS="8888 3306 4000"
ENV PORT=$PORTS
EXPOSE $PORT
USER root
RUN apk add erlang elixir npm
USER ${userName}
RUN mix local.hex --force && mix archive.install hex phx_new --force && mix local.rebar --force
