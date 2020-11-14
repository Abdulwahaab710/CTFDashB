#! /bin/sh

rake db:create db:migrate db:seed

exec "$@"
