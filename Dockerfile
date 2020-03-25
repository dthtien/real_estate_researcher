FROM ruby:2.6.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /toplands
WORKDIR /toplands
COPY Gemfile /toplands/Gemfile
RUN gem install bundler
RUN gem install bundler -v 1.17.3
COPY Gemfile.lock /toplands/Gemfile.lock
RUN bundle install
COPY . /toplands

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

