# CTFDashB
[![Build Status](https://travis-ci.com/Abdulwahaab710/CTFDashB.svg?token=bpyKsaqf92KAMzyEvsW1&branch=master)](https://travis-ci.com/Abdulwahaab710/CTFDashB)
[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=Abdulwahaab710/CTFDashB&identifier=107459121)](https://dependabot.com)
[![codecov](https://codecov.io/gh/Abdulwahaab710/CTFDashB/branch/master/graph/badge.svg?token=ohtoTFuMNi)](https://codecov.io/gh/Abdulwahaab710/CTFDashB)
![GitHub tag (latest by date)](https://img.shields.io/github/tag-date/Abdulwahaab710/CTFDashB.svg)

CTFDashB is a Capture The Flag dashboard.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Before we start you will need to have docker and docker-compose installed. You can download Docker Community Edition (CE) from [here](https://docs.docker.com/install/), which includes docker-compose.

### Installing

1. Clone the git repo

```sh
git clone git@github.com:Abdulwahaab710/CTFDashB.git
```

2. cd into the folder and create a dotenv file, like the following

```bash
# CTFDashB/.env
DATABASE_HOST=db
DATABASE_USERNAME=root
DATABASE_PASSWORD=S0ME_RANDOM_PASSWORD # you can use ruby generate the password ruby -e "require 'securerandom'; puts SecureRandom.hex()"
SECRET_KEY_BASE=S0ME_RANDOM_5TR1NG # you can use ruby generate the password ruby -e "require 'securerandom'; puts SecureRandom.hex()"
REDIS_URL=redis://redis
```
if this is for **production**, you will have to set the RAILS_ENV to be like the following

```bash
# CTFDashB/.env
...
RAILS_ENV=production
```

3. Build the containers

```sh
docker-compose build
```

4. Create the database, run Migration and seed the database

```sh
docker-compose run web rake db:create db:migrate db:seed
```

5. Run the application

```sh
docker-compose up
```

## Running the tests

To run tests

```
docker-compose run web bundle exec rspec
```

### And coding style (rubocop)

```
docker-compose run web bundle exec rubocop
```

To auto fix the violiation for rubocop

```
docker-compose run web bundle exec rubocop -a
```

## Deployment

Add additional notes about how to deploy this on a live system

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
