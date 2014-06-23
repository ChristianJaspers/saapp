# SAApp [![Build Status](https://magnum.travis-ci.com/Selleo/saapp.svg?token=vfpEEzsCSvdbps55fDew&branch=master)](https://magnum.travis-ci.com/Selleo/saapp) [![Dependency Status](https://gemnasium.com/414581dfdf7af56c503966f6408d430d.svg)](https://gemnasium.com/Selleo/saapp)

**Sales Argument App**

## Prerequisites

#### Environment

* Ruby 2.1.0

#### Database setup

* Create database: ```rake db:create db:migrate db:seed```

To setup test database, run `RAILS_ENV=test rake db:create db:migrate`

## Testing

#### Running tests

* Run ```rspec spec``` to run the whole suite

## Deployment to heroku (staging)


```
git push -f production master
heroku run rake db:migrate db:seed --app saapp-staging
```

## Deployment to heroku (production)


```
git push -f production master
heroku run rake db:migrate db:seed --app saapp-production
```

### HowTo

#### Set ENV vars on heroku manually

```
 heroku config:set some_var=some_value --app saapp-staging
```
