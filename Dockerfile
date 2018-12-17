
FROM crystallang/crystal AS build

ADD . /app
WORKDIR /app
RUN apt update
RUN shards build --release --static laborg

FROM alpine
LABEL maintainer=chussenot@vente-privee.com

WORKDIR /app
COPY --from=build /app/bin/laborg /usr/bin/

RUN addgroup -g 10001 app && \
    adduser -G app -u 10001 \
    -D -h /app -s /sbin/nologin app
USER app

CMD "laborg"
