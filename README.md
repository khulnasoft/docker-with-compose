## 🚨 DEPRECATION WARNING 🚨

As [Docker now has `compose` built in](https://github.com/docker-library/docker/pull/361) there's no longer need for this Docker image.

You should use the official [Docker image](https://hub.docker.com/_/docker/) instead.

---

[![Test](https://github.com/khulnasoft/docker-with-compose/workflows/Test/badge.svg)](https://github.com/khulnasoft/docker-with-compose/actions?query=workflow%3ATest) [![Deploy](https://github.com/khulnasoft/docker-with-compose/workflows/Deploy/badge.svg)](https://github.com/khulnasoft/docker-with-compose/actions?query=workflow%3ADeploy)

## Supported tags and respective `Dockerfile` links

* [`latest` _(Dockerfile)_](https://github.com/khulnasoft/docker-with-compose/blob/master/Dockerfile)

**Note**: There are [tags for each build date](https://hub.docker.com/r/khulnasoft/docker-with-compose/tags). If you need to "pin" the Docker image version you use, you can select one of those tags. E.g. `khulnasoft/docker-with-compose:2021-09-17`.

# Docker with Docker Compose image

[Docker image](https://hub.docker.com/_/docker/) with [Docker Compose](https://github.com/docker/compose) installed for CI.

## Description

The main purpose of this image is to help in Continuous Integration environments that need the `docker` binary, the `docker-compose` binary, and possibly require doing other small things, like running shell scripts or notifying some API with `curl`.

It includes both programs (`docker` and `docker-compose`) and allows to run arbitrary shell scripts (contrary to the official Docker Compose image).

By not having to install `docker-compose` on top of a `docker:latest` image it can reduce the building time about 10 / 15 seconds in a cloud data center for each build. In environments in where the Internet connection is less good than a cloud provider, the time saved would be more.

**GitHub repo**: <https://github.com/khulnasoft/docker-with-compose>

**Docker Hub image**: <https://hub.docker.com/r/khulnasoft/docker-with-compose/>

## Usage

Pull the image:

```console
$ docker pull khulnasoft/docker-with-compose
```

Then run a container of this image **mounting the Docker sock** as a host volume.

By mounting the Docker sock as a volume you allow the `docker` client inside of the container to communicate with your Docker (the Docker daemon/service) on your machine directly.

This way, you can send Docker commands, like pulling, running, or building a new Docker image, from inside this container.

You might also want to mount a host volume with the files that you need to use.

---

For example, let's say you have a `Dockerfile` like:

```Dockerfile
FROM nginx

RUN echo "Hello World" > /usr/share/nginx/html/index.html
```

You could:

* Mount the local directory containing that `Dockerfile`.
* Mount the local Docker sock.
* Build that Nginx image from inside of container running this image.

```console
$ docker run -v $(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock khulnasoft/docker-with-compose sh -c "cd /app/ && docker build -t custom-nginx ."
```

## Problem description

There is an official [Docker image](https://hub.docker.com/_/docker/) that contains the `docker` binary. And there is a [Docker Compose image](https://hub.docker.com/r/docker/compose/).

But the Docker Compose image has `docker-compose` as the entrypoint.

So, it's not possible to run other commands on that image, like installing something, e.g. `apt-get install -y curl`.

And it's also not possible to run `docker` commands directly, e.g. `docker login -u ci-user -p $CI_JOB_TOKEN $CI_REGISTRY`.

This image allows running arbitrary commands like shell scripts, `docker` commands and also Docker Compose commands like `docker-compose build` and `docker-compose push`.

As several Continuous Integration systems allow doing previous steps, like installing packages before running the actual main script, those steps could be used to install Docker Compose. But by downloading and installing Docker Compose every time, the builds would be slower.

For example, a very simple GitLab CI file `.gitlab-ci.yml` could look like:

```yml
# Do not use this file example
image: docker:latest

before_script:
  - apk add --no-cache py-pip
  - pip install docker-compose
  - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY

ci:
  script:
    - docker-compose build
    - docker-compose up -d
    - docker-compose exec -T tests run-tests.sh
    - docker-compose down -v
    - docker stack deploy -c docker-compose.prod.yml --with-registry-auth prod-example-com
```

But when the base image has to download and install Docker Compose every time, that's time added to the process. Specifically the lines in:

```yml
...

  - apk add --no-cache py-pip
  - pip install docker-compose

...
```

## This image's solution

This image includes Docker Compose and allows you to run any other arbitrary command.

So your GitLab CI `.gitlab-ci.yml` file could then look like:

```yml
image: khulnasoft/docker-with-compose

before_script:
  - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY

ci:
  script:
    - docker-compose build
    - docker-compose up -d
    - docker-compose exec -T tests run-tests.sh
    - docker-compose down -v
    - docker stack deploy -c docker-compose.prod.yml --with-registry-auth prod-example-com
```

And it would run faster as it doesn't have to install Docker Compose every time.

And you could start that initial GitLab Runner following the [GitLab CI runner for CI/CD guide on DockerSwarm.rocks](https://dockerswarm.rocks/gitlab-ci/).

The same would apply for Travis, Jenkins or whichever CI system you use.

## Release Notes

### Latest Changes

* 🗑️ Deprecate this project, use official Docker instead 🎉. PR [#47](https://github.com/khulnasoft/docker-with-compose/pull/47) by [@khulnasoft](https://github.com/khulnasoft).
* ⬆️ Bump actions/checkout from 3.1.0 to 3.3.0. PR [#44](https://github.com/khulnasoft/docker-with-compose/pull/44) by [@dependabot[bot]](https://github.com/apps/dependabot).
* 👷 Update Latest Changes token. PR [#46](https://github.com/khulnasoft/docker-with-compose/pull/46) by [@khulnasoft](https://github.com/khulnasoft).
* 👷 Add GitHub Action for Docker Hub description. PR [#41](https://github.com/khulnasoft/docker-with-compose/pull/41) by [@khulnasoft](https://github.com/khulnasoft).
* ⬆️ Upgrade CI OS. PR [#40](https://github.com/khulnasoft/docker-with-compose/pull/40) by [@khulnasoft](https://github.com/khulnasoft).
* 🔧 Add funding config. PR [#39](https://github.com/khulnasoft/docker-with-compose/pull/39) by [@khulnasoft](https://github.com/khulnasoft).
* 👷 Add automatic scheduled CI every monday. PR [#38](https://github.com/khulnasoft/docker-with-compose/pull/38) by [@khulnasoft](https://github.com/khulnasoft).
* 👷 Add automatic scheduled CI every Monday. PR [#37](https://github.com/khulnasoft/docker-with-compose/pull/37) by [@khulnasoft](https://github.com/khulnasoft).
* 📝 Update README, replace bash with shell, as Bash itself is not installed. PR [#36](https://github.com/khulnasoft/docker-with-compose/pull/36) by [@khulnasoft](https://github.com/khulnasoft).
* 👷 Add alls-green GitHub Action. PR [#35](https://github.com/khulnasoft/docker-with-compose/pull/35) by [@khulnasoft](https://github.com/khulnasoft).
* 👷 Do not run double CI for PRs, run on push only on master. PR [#34](https://github.com/khulnasoft/docker-with-compose/pull/34) by [@khulnasoft](https://github.com/khulnasoft).
* ⬆️ Bump khulnasoft/issue-manager from 0.3.0 to 0.4.0. PR [#28](https://github.com/khulnasoft/docker-with-compose/pull/28) by [@dependabot[bot]](https://github.com/apps/dependabot).
* Bump actions/checkout from 2 to 3.1.0. PR [#31](https://github.com/khulnasoft/docker-with-compose/pull/31) by [@dependabot[bot]](https://github.com/apps/dependabot).
* 🐛 Fix deployment. PR [#26](https://github.com/khulnasoft/docker-with-compose/pull/26) by [@khulnasoft](https://github.com/khulnasoft).
* 🐛 Fix GitHub Actions and latest requirements. PR [#25](https://github.com/khulnasoft/docker-with-compose/pull/25) by [@khulnasoft](https://github.com/khulnasoft).
* 👷 Move from Travis to GitHub Actions. PR [#23](https://github.com/khulnasoft/docker-with-compose/pull/23) by [@khulnasoft](https://github.com/khulnasoft).
* ✨ Add external dependencies and Dependabot to get automated upgrade PRs. PR [#27](https://github.com/khulnasoft/docker-with-compose/pull/27) by [@khulnasoft](https://github.com/khulnasoft).
* 👷 Add Latest Changes GitHub Action. PR [#24](https://github.com/khulnasoft/docker-with-compose/pull/24) by [@khulnasoft](https://github.com/khulnasoft).
* Upgrade Python to use version 3.x. PR [#15](https://github.com/khulnasoft/docker-with-compose/pull/15).
* Add `curl` to the installed and available packages. PR [#14](https://github.com/khulnasoft/docker-with-compose/pull/14) by [@stratosgear](https://github.com/stratosgear).
* Add Travis CI. PR [#4](https://github.com/khulnasoft/docker-with-compose/pull/4).
* Upgrade Docker Compose installation. PR [#3](https://github.com/khulnasoft/docker-with-compose/pull/3) by [@boskiv](https://github.com/boskiv).

## License

This project is licensed under the terms of the MIT license.
