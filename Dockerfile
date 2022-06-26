FROM ubuntu:20.04

ENV PYTHONBUFFERED=1

RUN \
    echo "**** Install Packages ****" && \
    apt-get update -y && apt-get install -y -qq \
    cron \
    wget \ 
    python3 \
    python3-pip \
    golang-go \ 
    nodejs \ 
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
    rm -rf /tmp/*

COPY src/ /src

COPY app/custom-cron /etc/cron.d/custom-cron

COPY app/script.py /app/script.py

RUN chmod 0744 /etc/cron.d/custom-cron && \
    crontab /etc/cron.d/custom-cron

CMD ["cron", "-f"]
