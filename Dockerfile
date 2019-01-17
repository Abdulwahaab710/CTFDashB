FROM ruby:latest


RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
      postgresql-client \
      nodejs \
      yarn \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists
RUN npm install yarn -g
WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

CMD rails assets:precompile
CMD bundle exec puma -C config/puma.rb
