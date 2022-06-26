FROM ubuntu:20.04

ENV PYTHONBUTTERED=1

RUN \
    echo "**** Install Packages ****" && \
    apt-get update -y && apt-get install -y -qq \
    cron \
    curl \ 
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/* && \
    echo "**** Get Pixlet ****" && \
    curl https://github.com/tidbyt/pixlet/releases/download/v0.17.9/pixlet_0.17.9_darwin_amd64.tar.gz -o /tmp/pixlet.tar.gz && \
    tar -xf /tmp/pixlet.tar.gz -C /usr/bin && \
    chmod +x /usr/bin/pixlet && \
    rm -rf /tmp/pixlet.tar.gz

COPY src/ /src

COPY app/custom-cron /etc/cron.d/custom-cron

COPY app/script.py /app/script.py

RUN chmod 0744 /etc/cron.d/custom-cron && \
    crontab /etc/cron.d/custom-cron

CMD ["cron", "-f"]
