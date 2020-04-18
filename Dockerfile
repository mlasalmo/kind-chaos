FROM python:3.8.2-alpine

COPY requirements.txt .

RUN apk add --no-cache --virtual build-deps \
      gcc \
      g++ \
      git \
      libffi-dev \
      linux-headers \
      musl-dev \
      python3-dev \
   && pip install --no-cache-dir -U pip \
   && pip install --no-cache-dir -r requirements.txt \
   && apk del build-deps \
   && rm -rf requirements.txt /var/cache/apk

ENTRYPOINT ["/usr/local/bin/chaos"]

CMD ["--help"]
