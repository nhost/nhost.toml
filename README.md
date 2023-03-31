# nhost.toml

This is a demo of the new configuration format nhost will use to keep the development and cloud environment fully in sync. We are keeping this in beta while we gather feedback and update the documentation.

## Schema

We are leveraging [cuelang](https://cuelang.org) to define the schema and validate the configuration. While we update our documentation the schema can be found [here](https://github.com/nhost/cli/blob/main/vendor/github.com/nhost/be/services/mimir/schema/schema.cue).


## Files

Two files are relevant to configure your project:

1. `./nhost/nhost.toml` which will hold the full configuration for the project. This configuration will be used in both your development environment and your cloud environment so make sure what you push to your git repo is what you will want deployed.
2. `./secrets` will hold secrets for your development environment. Your cloud secrets will need to be defined in the dashboard.

## Related CLI commands

* `nhost cli env` has been removed.
* `nhost init` will instantiate a new development environment and generate default `./nhost/nhost.toml` and `./secrets` files.
* `nhost init --remote` will instantiate a new development environment and pull `./nhost/nhost.toml` and `./secrets` from your cloud environment.
* `nhost config pull` can be used on an existing development environment to pull current versions of `./nhost/nhost.toml` and `./secrets` used in the cloud environment.
* `nhost config show-full-example` will print on screen a full example of the configuration.
* `nhost config validate [--remote]` can be used to validate your environments are properly configured.
* `nhost secrets create|delete|list|update` to work with secrets in the cloud environment.

IMPORTANT: When using `nhost init --remote` and `nhost config pull` review the downloaded files and make sure you don't push any sensitive information to git.

## Deploying configuration changes to production

Something very important to keep in mind is that if you have the file `./nhost/nhost.toml` in your connected git repository we will use it to configure your cloud environment overwriting any changes currently in there so make sure your configuration file is what you want in production.

## Beta docs

Head to the [./docs](docs) folder.

## Issues and Feedback

If you have any issue or want to provide feedback regarding usability, documentation or anything else don't hesitate to open an issue in this repository.
