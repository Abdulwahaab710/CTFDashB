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

2. cd into the folder and generate your `.env`, by running the following script

```bash
./generate-env
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
docker-compose up -d
```

## Contributing

To run the app in development mode, you will need to set the `RAILS_ENV` to `development`, or you can run the following script to generate your env with the correct environment

```sh
RAILS_ENV=development ./generate-env
```

### Running the tests

To run tests

```
docker-compose run web bundle exec rspec
```

#### And coding style (rubocop)

```
docker-compose run web bundle exec rubocop
```

To auto fix the violiation for rubocop

```
docker-compose run web bundle exec rubocop -a
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
