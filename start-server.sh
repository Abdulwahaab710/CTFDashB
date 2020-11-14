#!/usr/bin/env sh

set -e

if [ "$RAILS_ENV" == "production" ]
then
  bundle exec rails assets:precompile
fi
bundle exec rails server --binding 0.0.0.0 --port "${PORT:-3000}"
