FROM node:20 AS builder
ARG SPT_BRANCH=3.8.1

WORKDIR /opt

RUN apt update && apt install -yq git git-lfs curl
RUN git clone --branch $SPT_BRANCH https://dev.sp-tarkov.com/SPT-AKI/Server.git srv

WORKDIR /opt/srv/project 
RUN git-lfs fetch --all && git-lfs pull

RUN npm install && \
    npm run build:release -- --arch=$([ "$(uname -m)" = "aarch64" ] && echo arm64 || echo x64) --platform=linux && \
    mv build/ /opt/server/

FROM node:20
WORKDIR /opt/server
COPY --from=builder /opt/server /opt/srv
COPY start.sh /opt/start.sh
EXPOSE 6969
CMD bash /opt/start.sh
