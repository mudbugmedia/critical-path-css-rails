FROM ruby:2.5.0

# Install Dependencies
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs npm

RUN npm cache clean -f
RUN npm install -g n
RUN n 8.9.3
RUN ln -sf /usr/local/n/versions/node/8.9.3/bin/node /usr/bin/nodejs

ENV BUNDLE_PATH /gems

WORKDIR /app

COPY docker/ruby/startup.dev /usr/local/bin/startup
RUN chmod 755 /usr/local/bin/startup
CMD "/usr/local/bin/startup"