# Kraken Demo

This simple Infrastructure As Code Project demos a simple way to manage a cloud infrastructure



## Requirements

* [Python 3.8 MacOS](https://formulae.brew.sh/formula/python@3.8) - Reform uses python 3+
* [Reform](git@github.com:analogrithems/reform.git) - Reform simplifies creating our infra
* [Terraform 0.14.10 MacOS](https://formulae.brew.sh/formula/terraform) - This does the heavy lifting and creates our AWS resources
* [Terraform-Docs 0.12.1 MacOS](https://formulae.brew.sh/formula/terraform) - We use this to autogenerate docs in terraform
* [Docker](https://www.docker.com/products/docker-desktop) - helpful for testing local and even provides a mini k8s implementation to test with



## Development Setup

If you want to be able to try out reform locally you will need to make sure specific tools are installed. Use the quickstart guide below to do just that.

### QuickStart
Fastes way to get setup to develop under MacOS

```
$ brew install python@3.8 terraform terraform-docs docker
$ pip install git+ssh://git@github.com/analogrithems/reform.git
$ curl -s 'https://api.macapps.link/en/docker' | sh
```

>Note: Most people prefer to download the official docker image from the link i posted under requirements, the curl command above is a shortcut to do just that.  Feel free to skip that step if you already have it

For debugging purposes it's also recommended to install awscli example: ```pip install awscli```