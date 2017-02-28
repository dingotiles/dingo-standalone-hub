FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
COPY Gemfile* /tmp/
RUN cd /tmp/ && bundle install
