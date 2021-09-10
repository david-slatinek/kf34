#!/bin/bash

heroku container:login
docker image build -t kf34 .
heroku container:push web --app kf34
heroku container:release web --app kf34
