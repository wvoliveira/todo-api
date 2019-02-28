FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.6.0

COPY conf/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:9200/_cluster/health || exit 1
