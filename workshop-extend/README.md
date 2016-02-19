## Extend the image
To add more features to the image,
you probably want to 
   - reuse and upgrade npm cache
   - control user configuration, sharing her home directory 
   - map needed ports to test them

To be consistent when sharing volumes with host, use and
maintain the provided script [init_mounts](init_mounts.sh)

Here's a possible workflow

```sh
cd workshop_extend # this dir
name=extend_node4dev
# setup volumes
USER1=user1
./init_mounts.sh $USER1

# -- Create a named and interactive container
docker run -it \
   --name $name \
   -v `pwd`/$USER1:/home/$USER1 \
   -v `pwd`/$USER1/node-projects:/home/$USER1/node-projects \
   -v `pwd`/cache/npm:/var/local/cache/npm \
   -p 8080:8080 \
    rockyroad/node4dev /bin/bash
```

When you exit the session (with `exit` or `^D`), your work will persist with the container, that you can later restart with:

```sh
docker start -i $name
```

When you're happy with your work, go on to [workshop-build](../workshop-build/README.md)