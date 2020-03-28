FROM ruby:2.6-alpine
# Use virtual build-dependencies tag so we can remove these packages after bundle install
RUN apk update && apk add --update --no-cache --virtual build-dependency build-base ruby-dev postgresql-dev git

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /toplands
ENV RAILS_ENV=production
# make a new directory where our project will be copied
RUN mkdir -p $RAILS_ROOT
RUN gem install bundler
RUN gem install bundler -v 1.17.3

# Set working directory within container
WORKDIR $RAILS_ROOT

# Setting env up
ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV
ENV RAKE_ENV=$RAILS_ENV
ENV RACK_ENV=$RAILS_ENV

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# development/production differs in bundle install
RUN if [[ "$RAILS_ENV" == "production" ]]; then \
bundle install --jobs 20 --retry 5 --without development test;\
else bundle install --jobs 20 --retry 5; fi

# Remove build dependencies and install runtime dependencies
RUN apk del build-dependency
RUN apk add --update postgresql-client postgresql-libs nodejs tzdata

# Adding project files
COPY . .
#RUN rm config/database.yml
RUN cp config/database.yml.docker config/database.yml

#RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
