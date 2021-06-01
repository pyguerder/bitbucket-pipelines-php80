FROM ubuntu:18.04

MAINTAINER Pierre-Yves Guerder <pierreyves.guerder@gmail.com>

# Set environment variables
ENV HOME /root

# MySQL root password
ARG MYSQL_ROOT_PASS=root

# Cloudflare DNS
RUN echo "nameserver 1.1.1.1" | tee /etc/resolv.conf > /dev/null

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
    DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ondrej/php && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    ca-certificates \
    unzip \
    mcrypt \
    wget \
    openssl \
    ssh \
    locales \
    less \
    sudo \
    mysql-server \
    curl \
    gnupg \
    nodejs \
    --no-install-recommends

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    yarn \
    php8.0-mysql php8.0-zip php8.0-xml php8.0-mbstring php8.0-curl php8.0-pdo php8.0-tokenizer php8.0-cli php8.0-imap php8.0-intl php8.0-gd php8.0-xdebug php8.0-soap php8.0-apcu \
    apache2 libapache2-mod-php8.0 \
    --no-install-recommends && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/lib/mysql/ib_logfile*

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Ensure UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN locale-gen en_US.UTF-8

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Timezone & memory limit
RUN echo "date.timezone=Europe/Paris" > /etc/php/8.0/cli/conf.d/date_timezone.ini && echo "memory_limit=1G" >> /etc/php/8.0/apache2/php.ini

# Goto temporary directory.
WORKDIR /tmp
