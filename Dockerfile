FROM ruby:2.4.1

LABEL maintainer="https://github.com/kancolle0428/mastodon" \
      description="A GNU Social-compatible microblogging server"

ENV RAILS_ENV=production \
    NODE_ENV=production

EXPOSE 3000 4000

WORKDIR /mastodon

COPY Gemfile Gemfile.lock package.json yarn.lock /mastodon/

RUN echo 'deb http://httpredir.debian.org/debian jessie-backports main contrib non-free' >> /etc/apt/sources.list
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs ffmpeg && \
    rm -rf /var/lib/apt/lists/*


# -------------------
#   mysql
# -------------------

RUN apt-get update && apt-get install -y perl pwgen --no-install-recommends && rm -rf /var/lib/apt/lists/*

# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5

ENV MYSQL_MAJOR 5.7
ENV MYSQL_VERSION 5.7.18-1debian8

RUN echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list && \
    apt-get update && \
    apt-get install -y mysql-client="${MYSQL_VERSION}" libmysqlclient-dev="${MYSQL_VERSION}" && \
    rm -rf /var/lib/apt-lists/* &&\
    rm -rf /var/lib/mysql && \
    mkdir -p /var/lib/mysql


RUN npm install -g npm@3 && npm install -g yarn

ADD Gemfile /mastodon/Gemfile
ADD Gemfile.lock /mastodon/Gemfile.lock
RUN bundle install --deployment --without test development

ADD package.json /mastodon/package.json
ADD yarn.lock /mastodon/yarn.lock
RUN yarn --ignore-optional

COPY Gemfile Gemfile.lock package.json yarn.lock /mastodon/

RUN bundle install --deployment --without test development \
 && yarn --ignore-optional --pure-lockfile

COPY . /mastodon

VOLUME /mastodon/public/system /mastodon/public/assets /mastodon/public/packs
