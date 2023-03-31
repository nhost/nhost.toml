## Secrets and Variables

You can use secrets for two purposes:

1. To avoid placing sensitive information in your configuration file in plain
2. As placeholders for values that might differ between environments


For instance, imagine the following function:

``` typescript
import { Request, Response } from 'express'

export default (req: Request, res: Response) => {
    res.status(200).send(`${process.env.GREET_SECRET} ${req.query.name}!`)
}
```

Now, we want `GREET_SECRET` to be different depending on if we are in dev or production. Let's start by defining the environment variable:


``` toml
[[ global.environment ]]
name = 'GREET_SECRET'
value = "{{ secrets.GREET_TYPE }}"
```

Note that instead of the value, we are setting `{{ secrets.GREET_TYPE }}`. Now we need to create the secret `GREET_TYPE` in each environment.

1. In the development environment edit the file `.secrets` and add `GREET_TYPE=Heya`
2. In the cloud environment go to `https://app.nhost.io/$workspace/$project/settings/secrets` and add the secret. Alternatively, type `nhost secrets create GREET_TYPE Hola` to add the secret `GREET_TYPE` with the value `Hola` in the cloud environment.

Now, we can query both environments:

1. Dev:

```
$ curl https://local.functions.nhost.run/v1/greet-secret\?name=Nhost
Heya Nhost!
```

2. Prod:

```
$ curl https://eiptqtpugqjdrpelrihm.functions.eu-central-1.nhost.run/v1/greet-secret\?name=Nhost
Hello Mr. Nhost!
```

### Secrets Validation

If you add a secret to your configuration but forget to set it on your environment the issue will be detected and an error will be raised. For instance, let's add the following configuration:

``` toml
[auth.method.oauth.apple]
enabled = true
clientId = 'my-client-id'
keyId = '{{ secrets.APPLE_KEY_ID }}'
teamId = 'my-team-id'
scope = ['email', 'name']
privateKey = '{{ secrets.APPLE_PRIVATE_KEY }}'
```

Now, if we run `nhost config validate`, we will be informed our development environment is broken:

```
$ nhost config validate
> [failed to render config tempolate: failed to render template: variable not found: secrets.APPLE_KEY_ID] Configuration is invalid
```

Similarly, if we run `nhost config validate --remote` we should get a similar error:

```
$ nhost config validate --domain staging.nhost.run --remote
> [failed to render config tempolate: failed to render template: variable not found: secrets.APPLE_KEY_ID] Configuration is invalid
```

In addition, if you push this configuration to your environment the issue will be detected and the deployment will be aborted to avoid breaking anything.


To fix it, define your secrets in every environment. For example, adding them to `.secrets` should fix the development environment:

```
$ nhost config validate
> Configuration is valid
```

To fix your cloud environment go to `https://app.nhost.io/$workspace/$project/settings/secrets` and make sure you define them:

```
$ nhost config validate --domain staging.nhost.run --remote
> Configuration is valid
```
### Working with secrets from the cli

The nhost CLI has the ability to interact with your cloud environment and list, create, delete and update secrets for you. For instance:


```
# list
$  nhost secrets list
The following secrets are available:
====================================
HASURA_GRAPHQL_ADMIN_SECRET
HASURA_GRAPHQL_JWT_SECRET
NHOST_WEBHOOK_SECRET
GREET_TYPE
====================================

$ nhost secrets create APP_SECRET_KEY super-duper-secret
Secret 'APP_SECRET_KEY' created successfully

$ nhost secrets update APP_SECRET_KEY mynewsecret
Secret 'APP_SECRET_KEY' updated successfully

$ nhost secrets delete APP_SECRET_KEY
Secret 'APP_SECRET_KEY' deleted successfully
```

Keep in mind we always guarantee your configuration is as correct as possible so we won't allow you to delete by mistake in use:

```
$ nhost secrets delete GREET_TYPE
Error: failed to delete secret: variable required: secrets.GREET_TYPE
```

Changes are allowed so be mindful of that.
