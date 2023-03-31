# Downloading the CLI with support for `nhost.toml`

While this is in beta head to [releases](https://github.com/nhost/cli/releases) and download latest `0.10.x-beta` binary. Keep in mind a few things:

1. On Macos you may have to go to your Macos Settings->Security and allow the binary to run
2. Automatic updates don't work in this beta version so keep visiting the `releases` page for updates
3. All of the `nhost` commands in your project will need to use the binary you downloaded so replace the `nhost` command with the downloaded binary (i.e. `./cli dev`). You can also do `alias nhost=/path/to/binary` to keep things simpler.
