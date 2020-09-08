FROM ruby:2.7.1

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
 && apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/* \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install -yqq yarn

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
      postgresql-client \
      nmap \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN gem install bundler:2.0.2
RUN bundle install
CMD export PATH=$PATH:/root/.yarn/bin/yarn

COPY . .

# RUN yarn install --check-files

CMD bundle exec puma -C config/puma.rb
