- [System Pre-requisites](#system-pre-requisites)
- [Development](#development)
  - [Forking the codebase](#forking-the-codebase)
  - [Install dependencies](#install-dependencies)
  - [Run the tests](#run-the-tests)
  - [Run the application](#run-the-application)

# System Pre-requisites

The project requires [ruby 3.3.0](https://www.ruby-lang.org/en/news/2023/12/25/ruby-3-3-0-released/).

# Development

## Forking the codebase

If you are contributing to this codebase, with the intention of raising PRs, then please follow these guidelines:
* [Creating a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)
* [Raising a PR from your fork](https://docs.github.com/en/get-started/exploring-projects-on-github/contributing-to-a-project)

## Install dependencies

Install bundler, and all needed gems with:

```console
$ gem install bundler && bundle
```

The project makes use of `rake` to help you out carrying some common tasks, such as building the project or running it.

## Run the tests

```console
$ bundle exec rake specs
```

## Run the application

Run the application and access it [here](http://localhost:9292/)

```console
$ bundle exec rackup
```
