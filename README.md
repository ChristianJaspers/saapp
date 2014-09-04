# SAApp [![Build Status](https://magnum.travis-ci.com/Selleo/saapp.svg?token=vfpEEzsCSvdbps55fDew&branch=master)](https://magnum.travis-ci.com/Selleo/saapp) [![Dependency Status](https://gemnasium.com/414581dfdf7af56c503966f6408d430d.svg)](https://gemnasium.com/Selleo/saapp)

**BetterSalesman**

## Prerequisites

#### Environment

* Ruby 2.1.2

#### Copy configuration files

You need following files in you config directory

* `database.yml` (copied from database.yml.example)
* `application.yml` (ask other devs for contents)

#### Database setup

* Create database: ```rake db:create db:migrate db:seed```

To setup test database, run `RAILS_ENV=test rake db:create db:migrate`

#### Cms setup (only once)

Run to create cms pages placeholders

```
rake cms:setup --app saapp-staging
```

#### Email templates setup (only once)
```
rake email_templates:setup --app saapp-staging
```

## Testing

#### Running tests

* Run ```rspec spec``` to run the whole suite

## I18n
Do not use config/locales. Use PhraseApp.

If you want to add translation key. Change application.yml:
```
development:
  PHRASE_EDITOR_ENABLED: 'true'
```

And restart server - you will be able to use in-context PhraseApp editor.
When you are finished with translation you can turn off in-context editor.

### Before deployment

Update locales
```
phrase pull
git add ./phrase/locales
git commit -m "added new translations"
```

## Deployment to heroku (staging)

```
figaro heroku:set -e staging --app saapp-staging
git push -f staging master
heroku run rake db:migrate db:seed --app saapp-staging
heroku run rake email_templates:setup cms:setup --app saapp-staging
```

Staging app can be accessed through:

* saapp-staging.herokuapp.com
* staging.bettersalesman.com

## Deployment to heroku (production) [needs setup]

REMEMBER TO HAVE PROPER DATA SET (i.e. AWS keys, Mandrill etc.) IN YOUR APPLICATION YAML - IF YOU ARE NOT SURE CONTACT @bart.

```
figaro heroku:set -e production --app bettersalesman
git push -f production master
figaro heroku:set -e production --app bettersalesman
heroku run rake db:migrate db:seed --app bettersalesman
```

### HowTo

#### Set ENV vars on heroku manually

```
 heroku config:set some_var=some_value --app saapp-staging
```

#### application.yml & secrets.yml

##### application.yml (Figaro)

This file is NOT stored in repository and its variables are loaded into ENV. During the application setup configure your ```application.yml```. You should use ```application.yml.example``` template. 


##### secrets.yml (Rails)

This file is stored in repository and contains data that is shared between users.

#### Updating travis.yml with ENVs

Make sure you have ```application.yml``` and all keys for **test** group you want export to ```travis.yml``` exist, then run:

```rake
rake travis:encrypt_test_env
```

#### Add new email template

1. Add new file to `config/email_templates/import/en`
2. Edit just created email template (take other files as example)
3. Run `EmailTemplates::Setup.new.perform` from console
4. You can review your template on https://mandrillapp.com/templates/
5. Sending emails based on templates

```ruby
user = User.first
recipients = [EmailTemplates::Recipient.new(user.locale, user.email, {display_name: user.display_name})]
EmailTemplates::Sender.new(recipients, :user_invitation).send
```

#### Remove outdated objects from system

```
rake delayed_removal:perform
```

#### Download heroku database to test it locally
```
heroku pgbackups:capture --app saapp-staging
curl -o tmp/latest.dump `heroku pgbackups:url --app saapp-staging`
pg_restore --verbose --clean --no-acl --no-owner tmp/latest.dump > tmp/b.sql
rake db:drop db:create
psql -d sap < tmp/b.sql
rake db:migrate
```

