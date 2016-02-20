# docker-node4dev

A [docker](https://www.docker.com/) platform for developing web or 
nodejs applications.

Popular tools and frameworks pre-installed globally
ready to use.

Based on nodejs official node image.

The goal is to have a reliable and up-to-date development platform,
usable for different projects, rather than to make a slim image
with high performance. Reusability of image layers will be how
we save space.

Work in progress, image published on 
[dockerhub](https://hub.docker.com/r/rockyroad/node4dev/).

Comments welcome.

## How to run

### Synopsis
	name=mywebdevs
	mkdir -p $name && cd $_
    docker run -it \
       --name $name \
       -v `pwd`:/home/user1/node-projects \
       -v `pwd`/cache/npm:/var/local/cache/npm \
       -p 8080:8080 \
		rockyroad/node4dev /bin/bash

### Development life cycle use cases
  - [add features to this image](workshop-extend/README.md)
  - [rebuild extended image](workshop-build/README.md)
  - [use this image to develop your own project](workshop-apps/README.md)
  - [tailor a deployment image for your project](workshop-deploy/README.md)

## Base Image

This is the **nodejs official** image (link from
<https://nodejs.org/en/download/>) -&gt;
<https://hub.docker.com/_/node/>

Main features:

- FROM buildpack-deps:jessie
- node tar.xz downloaded, checked and extracted in *usr/local*
- `CMD [ "node" ]``

## Extra Debian packages
### man
makes sense to check how to use what's installed. If deciding to
not install it (e.g. for prod), you may want to clean the contents of
`$MANPATH` as well.

6503 kB for bsdmainutils groff-base libpipeline1 man-db 

### less 
would really be missing for working from the console.

259 kB of additional disk space 

### `tree` 
is helpful to quickly check an app's layout 102 kB of
additional disk space 

### `vim` 
could be optional considering that you
could as well edit files from the host system when it has some
directory mounted. 

28.9 MB of additional disk space for libgpm2 vim vim-common vim-runtime

### more system tools

Some simple scripts or statically linked app like
[`jq`](https://github.com/stedolan/jq) could live in the user's mounted
volume, e.g. \~/bin. So they are not included in the image.

## User account

Even in docker containers, doing experiments using the root account in
not recommended. Typically you will be generating an app in a mounted
volume and you don't want your files to be owned by `root`.

You can provide the **username** and **uid** of your choice as build 
arguments `USER1` and `UID1`, otherwise
the artistic name `user1` will be yours, with a *uid* of `1000`.

Permissions are designed to give you full access to `/usr/local` and 
`/var/local`, so that you will be able to install more packages globally .

For debugging purposes, you can still run the image with `-u root`
if needed.

## npm configuration
Node being installed with *prefix* `/usr/local`, *npm*
will install the global modules in `/usr/local/lib/node_modules`.
Settings can be adjusted for differents scopes:

-   per-project config file (`/path/to/my/project/.npmrc`)
-   per-user config file (`~/.npmrc`)
-   global config file (`$PREFIX/etc/npmrc`)
-   npm builtin config file (`/path/to/npm/npmrc`)

At docker image build time, the contents of the `./etc`
subdirectory is copied into `/usr/local/etc/`, so you can
customize the `./etc/npmrc` file in this directory to
change npm global configuration.

Be very careful though if you want to change the provided
**cache setting**, you will probably have to adjust the Dockerfile
accordingly.

## npm cache

npm cache having a default location of  `~/.npm` may explain that

-   if an "unauthorized" user tries to install a package globally, npm
    will first download it and then fail.
-   he will not be able to use root's cache ...

If npm cache has a global path, it needs to be writable by all,
like the global `nodes_modules`.

When you're tailoring your image to suit your needs, you may encounter errors
(e.g. unresolved package dependencies) and have to rebuild several times in
the day. To save time and bandwidth, you can provide already downloaded packages at build time in a tarball named `npm-cache.tar.xz` .
No directory components will be striped, so all your package directories
must appear at top level.

It would not be wise to include such a big file (and outdating fast)
in the git repo, but I included a symlink as a reminder.


## Updating npm
Two main methods around:

    npm update -g npm

or using the installer provided by npmjs:

    curl -L https://npmjs.org/install.sh | sh


## Volumes
- /home/$USER1/
- /home/$USER1/node-projects
- /var/local/cache (see below for details)

## Ports
 - 8080 8081 8082
 - 35729 for livereload  (to test)



## Npm packages

More to come when dependencies issues are solved. Help welcome.

