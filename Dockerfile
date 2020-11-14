FROM ruby:2.7.2-alpine

ARG APP_NAME=${APP_NAME:-recon}
ARG APP_GID=${APP_GID:-2000}
ARG APP_UID=${APP_UID:-2000}
ARG APP_HOME=${APP_HOME:-/app}
RUN addgroup -g ${APP_GID} ${APP_NAME} && \
    adduser -D \
    -h ${APP_HOME} \
    -s /bin/sh \
    -u ${APP_UID} \
    -G ${APP_NAME} \
    ${APP_NAME}

RUN apk add --no-cache build-base yarn nodejs nmap postgresql-dev tzdata git

WORKDIR ${APP_HOME}
USER ${APP_UID}:${APP_GID}
COPY --chown=${APP_UID}:${APP_GID} Gemfile Gemfile.lock ${APP_HOME}/
RUN gem install bundler:2.1.4
RUN bundle install

COPY --chown=${APP_UID}:${APP_GID} . ${APP_HOME}

EXPOSE 3000

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY start-server.sh /start-server.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/start-server.sh"]
