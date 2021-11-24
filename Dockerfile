FROM ruby:3.0.2-alpine3.14

ENV ROOT="/myapp"

WORKDIR ${ROOT}

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        gcc \
        g++ \
        libc-dev \
        libxml2-dev \
        linux-headers \
        make \
        nodejs \
        postgresql \
        postgresql-dev \
        tzdata \
        yarn && \
    apk add --virtual build-packs --no-cache \
        build-base \
        curl-dev

COPY Gemfile ${ROOT}
COPY Gemfile.lock ${ROOT}

RUN bundle install
RUN apk del build-packs

COPY . ${ROOT}

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]