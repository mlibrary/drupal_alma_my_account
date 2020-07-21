FROM ruby:2.5

LABEL maintainer="mrio@umich.edu"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

COPY rails/Gemfile* /usr/src/app/
WORKDIR /usr/src/app

RUN gem install bundler:2.1.4
ENV BUNDLE_PATH /gems

RUN bundle install

COPY ./rails /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
