FROM ruby:3.0.0

RUN touch /etc/app-env

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 5072E1F5 && \
    echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7" > /etc/apt/sources.list.d/mysql.list && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn libmysqlclient-dev mysql-client


WORKDIR /app

COPY Gemfile* /app/
COPY vendor/cache /app/vendor/cache
RUN bundle install --local

RUN mkdir /app/log

COPY . /app

EXPOSE 3000
CMD ["bundle", "exec", "puma"]