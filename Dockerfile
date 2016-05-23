FROM mongo:3.0

COPY start.sh /opt/bin/start.sh
RUN chmod +x /opt/bin/start.sh

USER mongodb
CMD ["/opt/bin/start.sh"]
