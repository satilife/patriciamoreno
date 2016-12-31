# patriciamoreno
The Primary Soul Camp Website

## Development

### Heroku Setup

```
heroku git:remote -a satilife-staging -r staging
heroku git:remote -a satilife-production -r production
```

### Clone production data
In order to clone production data to your local machine, you can use the following commands:

```shell
rake db:clone
```

### Sending Email in Development

On MacOSX, start the postfix server

```shell
sudo postfix start
```

This should start postfix on port `:25` which you can confirm with:

```shell
nc localhost 25
```

If this responds with something like `220 Machine-Name.localdomain ESMTP Postfix` then your should be good to go.
