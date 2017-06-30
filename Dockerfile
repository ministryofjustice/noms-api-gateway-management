FROM ruby:2.4.1-alpine

RUN apk add --update git build-base postgresql-dev linux-headers nodejs

WORKDIR /app
COPY . .
RUN bundle
