## Build an extended version of docker-node4dev
You'll probably start from work done in a container.

You can build your own image starting with

    FROM rockyroad/node4dev`

or, to synergize our efforts, work on a fork of this initial repo,
and then submit your [pull request]().

Given the layered architecture of docker images, this should
not increase your build time.

### First experiment interactively
see [add features to this image](workshop-extend/README.md)

### package your npm cache
Providing a new `npm-cache.tar.xz` will force the rebuild of the earlier layers, but it will speed up latest packages installation.

If you do, don't forget to delete your *dangling images* after successful 
build.

