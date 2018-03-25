#install the official Alpine Linux ruby v2.5.0 Docker image
FROM ruby:2.5.0-alpine

#create directory to house the application
RUN mkdir -p /silver_plan

#set the work directory
WORKDIR /silver_plan

#copy the workspace to the work directory
COPY Gemfile Gemfile.lock ./

#install all gems
RUN gem install bundler && bundle install --jobs 20 --retry 5

#copy the workspace to the work directory
COPY . ./


