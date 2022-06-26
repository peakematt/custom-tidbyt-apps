FROM ubuntu:22.04

ENV PYTHONBUFFERED=1

RUN \
    echo "**** Install Packages ****" && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \ 
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    cron \
    wget \ 
    python3 \
    python3-pip \
    golang-go \ 
    nodejs \ 
    npm \ 
    libwebp-dev \ 
    git \ 
    && rm -rf /var/lib/apt/lists/* && \
    echo "**** Get Pixlet ****" && \
    cd /tmp && \
    git clone https://github.com/tidbyt/pixlet && \ 
    cd pixlet && \
    npm install && \
    npm run build && \ 
    make build && \ 
    mv pixlet /usr/bin/pixlet && \ 
    chmod +x /usr/bin/pixlet && \
    rm -rf /tmp/* && \
    echo "**** Remove Unneeded Packages ****" && \
    apt-get purge -y \
    wget \ 
    golang-go \
    nodejs \
    npm \
    git && \
    apt-get autoremove -y

COPY src/ /src

COPY app/custom-cron /etc/cron.d/custom-cron
COPY app/script.py /app/script.py
COPY app/entrypoint.sh /app/entrypoint.sh

RUN chmod 0744 /etc/cron.d/custom-cron && \
    crontab /etc/cron.d/custom-cron && \
    chmod 0744 /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
