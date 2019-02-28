FROM docker.elastic.co/kibana/kibana-oss:6.6.0

COPY conf/kibana.yml /usr/share/kibana/config/kibana.yml

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://127.0.0.1:5601/ || exit 1
