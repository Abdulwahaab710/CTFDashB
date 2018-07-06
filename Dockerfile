FROM ruby:latest

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
