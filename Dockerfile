FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

EXPOSE 5000
ENV PORT=5000

COPY . /app
RUN cd /app && bundle install
WORKDIR /app

ENTRYPOINT ["bin/rails", "server"]
