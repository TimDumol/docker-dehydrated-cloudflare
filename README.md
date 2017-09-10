# docker-docker-dehydrated-cloudflare

A Docker image for obtaining Let's Encrypt SSL certificates for Cloudflare domains using [dehydrated](https://github.com/lukas2511/dehydrated) and [kappataumu/letsencrypt-cloudflare-hook](https://github.com/kappataumu/letsencrypt-cloudflare-hook).

## Usage

In order to use this image, you must expose your Cloudflare account's email and API key in the environment as the `CF_EMAIL` and `CF_KEY`, and then mount `/dehydrated/certs` to where you want your SSL certs to go.

```
$ docker create -v /etc/ssl/certs:/dehydrated/certs -v /dehydrated/accounts --name dehydrated-data timdumol/docker-dehydrated-cloudflare
$ docker run --rm -e CF_EMAIL='user@example.com' -e CF_KEY=AbCd12345678 --volumes-from dehydrated-data timdumol/docker-dehydrated-cloudflare --register --accept-terms
$ docker run --rm -e CF_EMAIL='user@example.com' -e CF_KEY=AbCd12345678 --volumes-from dehydrated-data timdumol/docker-dehydrated-cloudflare --cron -d www.example.com
```

You can also use the environment variable `CF_DNS_SERVERS` to specify the DNS servers to be used for propagation checking, and `CF_DEBUG=true` to see more details about the hook's execution. Configuration for dehydrated is also available by setting the appropriate environemnt variable (see `config.tmpl` for the full list of variables):

```
$ docker run --rm -e CONTACT_EMAIL='user@example.com' -e CF_EMAIL='user@example.com' -e CF_KEY=AbCd12345678 --volumes-from dehydrated-data timdumol/docker-dehydrated-cloudflare --cron -d www.example.com
```
