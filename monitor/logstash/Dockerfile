FROM docker.elastic.co/logstash/logstash-oss:6.6.0

COPY conf/logstash.conf /usr/share/logstash/pipeline/logstash.conf

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://127.0.0.1:9600 || exit 1
