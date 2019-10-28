FROM ruby@sha256:17dfe500c50516f6f6b65e9d2a662e93da4f65561eff6e756cc411ccace41682

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
      postgresql-client \
      nodejs \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

CMD bundle exec puma -C config/puma.rb
