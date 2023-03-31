# Deploying to a new project

## Forking repo and creating nhost project

In this scenario we are deploying a development environment to a new project. As an example we are going to use this very same repo.

1. Start by forking this project on Github to your personal organization.
2. Now clone the repo to your local workspace (i.e. `git clone git@github.com:dbarrosop/nhost.toml.git`)
3. Create a new project on [https://app.nhost.io](Nhost)
4. Once the project is done being created:
  1. Click on "Connect to Github"
  2. If you can't see your fork go to "Manage your Github Connection" and follow the steps to allow the Nhost App to see your repo.
  3. Once you can see your repo under "Connect to Github" click on "Connect" and then "Connect Repository" leaving everything untouched.

At this point we will see a deployment occured but failed:

![initial deployment failed](initial-deployment-failed.png)

This is expected at this point.

## Fixing the development environment

```
$ nhost dev

Error: failed to resolve config: failed to render config tempolate: failed to render template: variable not found: secrets.GREET_TYPE
```

Looks like the cli has detected some misconfiguration and failed to start. If we look at the [/nhost/nhost.toml](configuration) we will see we are referencing a secret:

```toml
[[ global.environment ]]
name = 'GREET_TYPE'
value = "{{ secrets.GREET_TYPE }}"
```

We can also confirm this fact with the command `nhost config validate`:

```
$ nhost config validate
> [failed to render config tempolate: failed to render template: variable not found: secrets.GREET_TYPE] Configuration is invalid
```

So we let's add this secret to the `.secrets` file. We are going to be adding a couple of more secrets that are also needed to make sure hasura works in our development environment:

```
HASURA_GRAPHQL_ADMIN_SECRET=nhost-admin-secret
HASURA_GRAPHQL_JWT_SECRET=0f987876650b4a085e64594fae9219e7781b17506bec02489ad061fba8cb22db
NHOST_WEBHOOK_SECRET=nhost-webhook-secret
GREET_TYPE=Heya
```

Now let's try again:

```
$ nhost config validate
> Configuration is valid

$ nhost dev

> Ready to use

URLs:
- Postgres:             postgres://postgres:postgres@local.db.nhost.run:5432/postgres
- Hasura:               https://local.hasura.nhost.run
- GraphQL:              https://local.graphql.nhost.run/v1
- Auth:                 https://local.auth.nhost.run/v1
- Storage:              https://local.storage.nhost.run/v1
- Functions:            https://local.functions.nhost.run/v1

- Dashboard:            http://localhost:3030
- Mailhog:              http://localhost:8025
```

It worked!!!

```
$ curl https://local.functions.nhost.run/v1/greet-plain\?name=Nhost
Sayonara Nhost!

$ curl https://local.functions.nhost.run/v1/greet-secret\?name=Nhost
Heya Nhost!
```

## Fixing the cloud environment

Now that the development environment is up and running let's fix the cloud environment. Let's start by logging in with the cli and linking the project:

```
$ nhost login
Email: [REDACTED]
> Type `nhost list` to see your remote apps

$ nhost list

App         Workspace
----        ---------
nhost.toml  Nhost

$ nhost link
✔ Selected: nhost.toml  Nhost
Enter the app's name to confirm linking (case sensitive): nhost.toml
> App linked to local Nhost environment
```

Done. Now we can validate the cloud environment:

```
$ nhost config validate --remote
> [failed to render config tempolate: failed to render template: variable not found: secrets.GREET_TYPE] Configuration is invalid
```

Looks like the secret is missing, so let's head to `https://app.nhost.io/$workspace/$project/settings/secrets` and add it:

![adding-secret](adding-secret.png)

You can see in the background that the secrets for hasura were automatically pre-created for you.


Now let's try to validate the configuration again:

```
$ nhost config validate --remote
> Configuration is valid
```

## Redeploying

Now that we have fixed the cloud environment we can simply reattempt the previous deployment.

![redeploy](redeploy.png)

![success](success.png)

We can test querying the functions:

```
$ curl https://eiptqtpugqjdrpelrihm.functions.eu-central-1.nhost.run/v1/greet-plain\?name=Nhost
Sayonara Nhost!

$ curl https://eiptqtpugqjdrpelrihm.functions.eu-central-1.nhost.run/v1/greet-secret\?name=Nhost
Hello Mr. Nhost!
```

Notice that `greet-secret` function returned a slightly different string when querying our local environment, that was thanks to the fact we were using secrets to set the `GREET_TYPE` environment variable and that each environment had a different value for it.

## Final notes

Keep in mind that the only step necessary to successfully deploy the project was to add the secret `GREET_TYPE`. Rest of the steps weren't really necessary but having the correct workflow will help you ensure your local and cloud environments are in synch at that you can make changes with confidence.
