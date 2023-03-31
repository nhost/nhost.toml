# Validating configuration

The new configuration comes with strong checks to make sure settings are correct (i.e. no missing settings, values look correct, etc.) and we will abort the deployment if the validations don't pass but if your values are not good (i.e. wrong secret for an oauth provider) it is impossible for us to detect ahead of time. However, as settings are now on github reverting to a previous known state should be as trivial as reverting a commit in git and pushing again.

For instance, let's imagine we want to configure apple as an oauth provider. So we enable it in our configuration file:


``` toml
[auth.method.oauth.apple]
enabled = true
```

Now we can validate our environment:

```
$ nhost config validate
> [config is not valid: #Config.auth.method.oauth.apple.clientId: incomplete value string (and 3 more errors)] Configuration is invalid
```

Apparently we are missing `clientId` and 3 more fields. Let's fix it:


``` toml
[auth.method.oauth.apple]
enabled = true
clientId = "my-client-id"
keyId = "{{ secrets.APPLE_KEY_ID }}"
teamId = "my-team-id"
privateKey = "{{ secrets.APPLE_PRIVATE_KEY }}"
```

Now if we validate the config again:

```
$ nhost config validate
> Configuration is valid
```

However, this configuration is using secrets (more on this later) and those need to be defined in the cloud environment or the deployment will fail. We can validate our current configuration will work in production adding `--remote` option:

```
nhost config validate --remote
> [failed to render config tempolate: failed to render template: variable not found: secrets.APPLE_KEY_ID] Configuration is invalid
```

As you can see we are being warned that we are missing secrets in our cloud environment.

If we add the secrets to the cloud environment and try again:

```
$ nhost config validate --remote
> Configuration is valid
```
