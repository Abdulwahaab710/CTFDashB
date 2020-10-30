#! /bin/bash

rake db:create db:migrate db:seed
if [ "$RAILS_ENV" = "production" ]
then
  rake assets:precompile
fi
export COLUMNS=`tput cols`;
export LINES=`tput lines`;

exec "$@"
