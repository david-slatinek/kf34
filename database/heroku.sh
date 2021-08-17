#!/bin/bash
#heroku container:login
#heroku create kf34-db --region eu
#heroku addons:create --app kf34-db heroku-postgresql:hobby-dev
#heroku pg:psql --app kf34-db <db.sql
heroku pg:psql -a kf34-db
