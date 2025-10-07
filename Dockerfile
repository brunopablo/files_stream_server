FROM ubuntu:24.04

# Instala dependências necessárias
RUN apt update && apt upgrade -y && \
    apt install -y build-essential libpcre3 libpcre3-dev libssl-dev zlib1g zlib1g-dev unzip bzip2 wget

# Diretório de trabalho
WORKDIR /usr/local/src

# Baixa o NGINX e o módulo RTMP
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/master.zip && \
    tar -zxvf nginx-1.21.6.tar.gz && \
    unzip master.zip

# Compila o NGINX com o módulo RTMP
WORKDIR /usr/local/src/nginx-1.21.6
RUN ./configure --add-module=../nginx-rtmp-module-master --with-http_ssl_module && \
    make && \
    make install

# Cria diretórios para HLS/DASH
RUN mkdir -p /container_nginx/hls /container_nginx/dash


# Expõe as portas necessárias
EXPOSE 1935 8080

# Copia o nginx.conf personalizado (você vai montar isso depois via volume)
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
