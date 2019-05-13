FROM ruby:2.6.3-alpine

RUN apk add --update git build-base postgresql-dev linux-headers nodejs

RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

COPY Gemfile* /app/
WORKDIR /app
RUN bundle install

COPY . .

RUN chown -R appuser:appgroup /app

USER 1000

CMD ["rails", "server", "--binding", "0.0.0.0"]
