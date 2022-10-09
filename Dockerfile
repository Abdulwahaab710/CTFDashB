FROM ruby:3.1.2

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
      postgresql-client \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN gem install bundler:2.1.4
RUN bundle install
COPY . .

CMD bundle exec puma -C config/puma.rb
