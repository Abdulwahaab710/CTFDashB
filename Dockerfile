FROM ruby@sha256:0048434fd0ea67f0c8fc5d959a38751fced429c3c80c28e293518486f9039723

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
