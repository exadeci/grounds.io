# grounds.io
[ ![Codeship Status for grounds/grounds.io](https://codeship.io/projects/ad989680-2460-0132-1117-12e55c6fdf6c/status)](https://codeship.io/projects/36826)

This project is the web application behind [Grounds](http://beta.42grounds.io).

Grounds is a 100% open source developer tool built to provide a way to share
runnable snippets within various languages from a web browser.

Grounds is using a [socket.io](http://socket.io/) server to execute arbitrary
code inside Docker containers, called grounds-exec. grounds-exec has its own
repository [here](https://github.com/grounds/grounds-exec).

All you need is [Docker 1.3+](https://docker.com/), [Fig 1.0+](http://www.fig.sh/)
and [make](http://www.gnu.org/software/make/) to run this project inside Docker
containers with the same environment as in production.

## Languages

Grounds currently supports latest version of:

* C
* C++
* C#
* Elixir
* Go
* Java
* Node.js
* PHP
* Python 2 and 3
* Ruby
* Rust

Checkout this [documentation](/docs/NEW_LANGUAGE.md) to get more informations
about how to add support for a new language stack.

## Prerequisite

Grounds is a [Ruby on Rails](http://rubyonrails.org/) web application.

Grounds is using the latest version of grounds-exec and will automatically
pull the latest Docker image.

Grounds requires a [Redis](http://redis.io/) instance and will automatically
spawn a Docker container with a new Redis instance inside.

### Pull language stack Docker images

    make pull

If you want to pull these images from your own repository:

    REPOSITORY="<you repository>" make pull

>Pulling all language stack images can take a long time and a lot of space.
However, only ruby image is mandatory when running the test suite.

Pull a specific language stack image:

    docker pull grounds/exec-ruby

Checkout all available images on the official
[repository](https://registry.hub.docker.com/repos/grounds/).

### Set Docker remote API url

You need to specify a Docker remote API url to connect with.

    export DOCKER_URL="https://127.0.0.1:2375"

If your are using Docker API through `https`, your `DOCKER_CERT_PATH` will be
mounted has a volume inside the container.

>Be careful: boot2docker enforces tls verification since version 1.3.

## Launch the web application

    make run

The web app should now be listening on port 3000 on your docker daemon (if you
are  using boot2docker, `boot2docker ip` will tell you its address).

You can also run Grounds in production mode:

    RAILS_ENV=production make run

>When running in production mode, a default secret key is set as convenience,
but this should be changed in production by specifying `SECRET_KEY_BASE`.

If you want [New Relic](http://newrelic.com/) metrics you can also specify:

* `NEWRELIC_LICENSE_KEY`
* `NEWRELIC_APP_NAME`

>New Relic metrics are available only when running in production mode.

## Open rails console

For ease of debugging, you can open a rails console inside a container:

    make console

## Install / Update ruby gems

You can update `Gemfile.lock` inside a container with:

* When installing a new gem:

        make install

* When updating existing gems:

        make update

## Tests

Tests will also run inside Docker containers with the same environment
as the CI server.

To run the test suite:

    make test

To run specific test files or add a flag for [RSpec](http://rspec.info/) you can
specify `TEST_OPTS`:

    TEST_OPTS="spec/models/ground_spec.rb" make test

## Contributing

Before sending a pull request, please checkout the contributing
[guidelines](/docs/CONTRIBUTING.md).

## Authors

See [authors](/docs/AUTHORS.md) file.

## Licensing

grounds.io is licensed under the MIT License. See [LICENSE](LICENSE) for full
license text.
