FROM ruby:2.6.3

ARG e
ENV RAILS_VERSION 5.2.3
ENV RAILS_ENV=$e

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && \
curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
RUN gem install sprockets -v 3.7.2 && \
gem install rails -v "$RAILS_VERSION"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
# COPY . /usr/src/app
# RUN bundle install
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN $HOME/.yarn/bin/yarn install

COPY pre_run.sh /usr/src/app
RUN chmod ugo+xr /usr/src/app/pre_run.sh

ENTRYPOINT ["/usr/src/app/pre_run.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]