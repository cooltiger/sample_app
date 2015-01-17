# Sample App for learning rails
[![Build Status](https://travis-ci.org/cooltiger/sample_app.svg?branch=master)](https://travis-ci.org/cooltiger/sample_app)
[![Coverage Status](https://coveralls.io/repos/cooltiger/sample_app/badge.svg)](https://coveralls.io/r/cooltiger/sample_app)

== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation
```
# if it is the first time to create, use the follow command
bundle exec rake db:migrate
bundle exec rake db:migrate RAILS_ENV=test

# if you want to reset the db, use the follow command
bundle exec rake db:reset
```

* Database initialization
```
# create fake data in development enviroment
bundle exec rake db:populate
```

* How to run the test suite
```
bundle exec rspec spec/
```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
