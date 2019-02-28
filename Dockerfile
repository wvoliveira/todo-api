FROM python:3.6-alpine

WORKDIR /app

COPY requirements.txt .

RUN apk add --no-cache curl && \
    pip install -r requirements.txt

COPY . /app

EXPOSE 5000

ENTRYPOINT ["python", "app.py"]

HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -s http://localhost:5000/healthcheck || exit 1

