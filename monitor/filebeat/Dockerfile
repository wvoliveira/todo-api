FROM docker.elastic.co/beats/filebeat-oss:6.6.0

# I know, i know
USER root

COPY conf/filebeat.yml /usr/share/filebeat/filebeat.yml
RUN chmod go-w /usr/share/filebeat/filebeat.yml

HEALTHCHECK --interval=5s --timeout=3s \
    CMD ps aux | grep '[f]ilebeat' || exit 1
