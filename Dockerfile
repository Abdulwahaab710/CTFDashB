FROM ruby@sha256:32f2edd01c5b35f900a1e4a45016d18697be4611d05ccea2ee4e799d142bd894

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
      postgresql-client \
      nodejs \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

RUN gem install bundler

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

CMD bundle exec puma -C config/puma.rb
