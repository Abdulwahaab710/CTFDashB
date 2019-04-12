# CTFDashB
[![Build Status](https://travis-ci.com/Abdulwahaab710/CTFDashB.svg?token=bpyKsaqf92KAMzyEvsW1&branch=master)](https://travis-ci.com/Abdulwahaab710/CTFDashB)
[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=Abdulwahaab710/CTFDashB&identifier=107459121)](https://dependabot.com)
[![codecov](https://codecov.io/gh/Abdulwahaab710/CTFDashB/branch/master/graph/badge.svg?token=ohtoTFuMNi)](https://codecov.io/gh/Abdulwahaab710/CTFDashB)

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

2. Build the containers

```sh
docker-compose build
```

3. Create the database, run Migration and seed the database

```sh
docker-compose run web rake db:create db:migrate db:seed
```

4. Run the application

```sh
docker-compose up
```

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
