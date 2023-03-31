# Environment Variables

You can add environment variables to your environment by editing the configuration file and adding:

``` toml
[[ global.environment ]]
name = 'GREET_PLAIN'
value = "Sayonara"
```

Then you can use them as usual. For instance, in a function like this:


``` typescript
import { Request, Response } from 'express'

export default (req: Request, res: Response) => {
    res.status(200).send(`${process.env.GREET_PLAIN} ${req.query.name}!`)
}
```

Now if we start `nhost dev` and query the function we should see the following:

```
$ curl https://local.functions.nhost.run/v1/greet-plain\?name=Nhost
Sayonara Nhost!
```
