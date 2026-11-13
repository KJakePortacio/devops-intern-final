FROM nginx:1.30.6-alpine3.24-slim

ARG BUILD_SHA=local

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html styles.css /usr/share/nginx/html/

RUN sed -i "s/__BUILD_SHA__/${BUILD_SHA}/g" /usr/share/nginx/html/index.html

USER nginx

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["wget", "-q", "-O", "/dev/null", "http://127.0.0.1:8080/healthz"]