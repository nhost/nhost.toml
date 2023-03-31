# Managing Settings and Versions

You can fully control your development and cloud environments keeping them in synch by making changes to the configuration file. For instance, let's see which `hasura-auth` version we are using. We can start by checking the configuration:

``` toml
...

[auth]
version = '0.19.0'

...

```

We can confirm by querying the `/version` endpoint:

```
$ curl https://local.auth.nhost.run/v1/version
{"version":"v0.19.0"}

$ curl https://eiptqtpugqjdrpelrihm.auth.eu-central-1.nhost.run/v1/version
{"version":"v0.19.0"}
```

We can also verify the configured expiration time of the refresh token in the same configuration file:

``` toml
[auth.session.refreshToken]
expiresIn = 43200
```
Now, let's change the configuration to:

```toml
...

[auth]
version = '0.19.1'

[auth.session.refreshToken]
expiresIn = 2592000
...
```

and restart the local environment:


```
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

- subdomain:            local
- region:               (empty)
```

In another shell we try querying the `/version` endpoint again:

```
$ curl https://local.auth.nhost.run/v1/version
{"version":"v0.19.1"}
```

We can also verify the refresh token expiration timer by inspecting the docker container locally (note that you may need to adapt the command for your environment):

```
docker inspect nhost-toml-elated_pascal-auth-1 | grep REFRESH
                "AUTH_REFRESH_TOKEN_EXPIRES_IN=2592000",
```

Now we can commit and push to git the configuration change alongside any migrations and metadata changes that might have been done by the upgrade:

```
$ git add .

$ git commit -m "update hasura-auth to 0.19.1"
[main 3686fd7] update hasura-auth to 0.19.1
 1 file changed, 1 insertion(+), 1 deletion(-)

$ git push
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 358 bytes | 358.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
To github.com:dbarrosop/nhost.toml.git
 + 2ab2675...3686fd7 main -> main
```

Now we can wait for the deployment to finish:

![deployment](deployment.png)

Now we can query the `/version` endpoint again:

```
$ curl https://eiptqtpugqjdrpelrihm.auth.eu-central-1.nhost.run/v1/version
{"version":"v0.19.1"}
```
