# README

## To use Client Keeper:

* Clone or download the repository

* Run `bundle install`

*  Then set up the database and seed data with:
```
rails db:migrate
rails db:seed
```
or
```
rails db:setup
```

* You will need to setup your environment variables in order to use the Marqeta APIs:
  * Create a file as `config/environment_variables.yml`.
  * In this file, add the following variables: `APPLICATION_TOKEN`, `MASTER_TOKEN`, and `BASE_URL`.
  * Once you sign up or log in, you can find the the appropriate values for each at `https://www.marqeta.com/api-explorer`

* Finally to start up the app run `rails server`


## A couple notes
This is still a work in progress so...

* Please note that there are some areas that would create serious security risks in a real life scenario.

* Tests are primarily not yet set up

* There is a lot of excess in the schema/db (and the app in general)

* And most of all, please feel free to offer any suggestions or point out any issues!
