# Haskell Build Environment with Cabal on Raspberry Pi

We share this here in case it can help folks out there.


## Setup

We need this for a project on Raspberry Pi 4B.

We build on a 8GB RAM with a 32GB SSD.

I suggest using a bigger SSD since we are struggling with storage full issues.


## Objectives

### Benefit of the `haskell-language-server`

First, we want to be able to use the latest versions of `ghc` so that we can use the `haskell-language-server` when developping... hehe.

With the available package of `stack` on Raspberry OS, we only managed to get `ghc` 8.6.3 working but it is too old to be supported by `haskell-language-server`.


### Reduce Build Time

Second, we want a setup that uses cache to reduce build time that is excruciating when building the dependencies :P

Only using the docker cache was not amazing for us since the cache was sometimes invalidated or flushed (!?) and we had to rebuild the dependencies way too often.


## Requirements

### Host (Raspberry Pi)

* `docker`

#### Fix `apt` issues

Right now, as of January 31st 2021, we must update the `libseccomp` for apt to work in docker images:

* Download info [here](https://packages.debian.org/sid/armhf/libseccomp2/download)

```bash
wget http://ftp.us.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.1-1_armhf.deb
sudo dpkg -i libseccomp2_2.5.1-1_armhf.deb
```


## Build the Haskell Build Environment

So ! We want to build an environment with `ghc` and `cabal` that we'll be able to use to build our Haskell project on Raspberry Pi.

We can do this running this command with this repo as current working directory:

`DOCKER_BUILDKIT=1 DOCKER_CLI_EXPERIMENTAL=enabled docker build . -t haskell-builder`

It took me 1h45 to build on the setup described above.


## Build with the Environment

Once we have that environment, we can start it with:

`docker run -v /home/pi/my-project-root:/project -v /home/pi/cabal-cache:/root/.cabal -it haskell-builder bash`

Once in the container shell:

`cd project
cabal update # The first time
cabal build
`

Adapt the paths if needed !

Enjoy :)


## Versions used

* `ghc` 8.10.3
* `cabal-install` 3.2


## Stack Users

I suggest using [`stack2cabal`](https://hackage.haskell.org/package/stack2cabal) to use the same package version and avoid surprises.

I haven't tried it yet but we got bitten by a different AESON package version already so I am definitely gonna try it !


## Ressources that Helped

* [Cabal problem with `fdTryLock`](https://github.com/haskell/cabal/issues/6602)
* [With Raspberry Pi OS](https://gitlab.haskell.org/ghc/ghc/-/issues/17856)
* Apt failure in docker on RPi
    * The [apt security error](https://github.com/debuerreotype/docker-debian-artifacts/issues/101)
    * Seems caused by [the libseccomp that is too old in the Raspberry Pi OS repo](https://github.com/debuerreotype/docker-debian-artifacts/issues/97)
    * [Solution](https://stackoverflow.com/a/64463211/3687661)
* [Problems with RPi architecture schizophrenia and basic Dockerfile idea](https://gitlab.haskell.org/ghc/ghc/-/issues/17856) (lower in comments)
* [How to use `stack` on RPi](https://svejcar.dev/posts/2019/09/23/haskell-on-raspberry-pi-4/#solving-troubles-with-ghc)

