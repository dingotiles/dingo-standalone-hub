FROM dingotiles/dingo-standalone-hub-base

EXPOSE 5000
ENV PORT=5000

COPY . /app
RUN cd /app && bundle install
WORKDIR /app

CMD ["/app/startup.sh"]
