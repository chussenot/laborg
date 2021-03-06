# laborg

[![Build Status](https://www.travis-ci.org/chussenot/laborg.svg?branch=master)](https://www.travis-ci.org/chussenot/laborg)

ORG*anize the groups!

`laborg` is CLI to manage the first groups of:

* GitLab
* Artifactory

## Installation

TODO: Write installation instructions here

## Usage

```

  Laborg CLI.

  Usage:

    laborg [options] [arguments]

  Options:

    --help                           Show this help.

  Sub Commands:

    plan    Generate an execution plan and compare it
    apply   Builds or Changes the first level groups

```

### Help

`GITLAB_TOKEN=xxxxxx GITLAB_HOST=https://git.mycompany.org laborg --help`

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/chussenot/laborg/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Clement Hussenot](https://github.com/chussenot) - creator and maintainer

## Resources

* [Artifactory Ruby Client](https://github.com/chef/artifactory-client)
* [Gitlab Python Client](https://python-gitlab.readthedocs.io/en/stable/gl_objects/groups.html#group-custom-attributes)
* [Gitlab Custom Attributes](https://docs.gitlab.com/ce/api/custom_attributes.html)
