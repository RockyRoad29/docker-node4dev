FROM node
MAINTAINER RockyRoad

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    man \
    less \
    tree \
    vim    


ARG USER1=user1
ARG UID1=1000

RUN useradd -ms /bin/bash -Uu $UID1 -G staff $USER1

# Allow cache persistence:
#RUN echo cache = /var/local/cache/npm > /usr/local/etc/npmrc
ADD etc/* /usr/local/etc/
RUN mkdir -p /var/local/cache/npm
ADD npm-cache.tar.xz /var/local/cache/npm
RUN chown -R root:staff /var/local/*
RUN chmod g+w -R /var/local/*

# give way to npm install -g
RUN chown -R root:staff /usr/local/*
RUN chmod g+w -R  /usr/local/*

# npm management is all done from user account
USER $USER1
RUN mkdir -p /home/$USER1/node-projects
WORKDIR /home/$USER1/node-projects
# Allow user env or projects persistence
VOLUME /home/$USER1
# or, avoiding config files
VOLUME /home/$USER1/node-projects
# if you want to share npm cache
VOLUME /var/local/cache/npm
# nodejs usual ports
EXPOSE 8080 8081 8082
# for livereload - TESTME
EXPOSE 35729

# Check user write access for npm -g before going any further
RUN (if [ ! -w /var/local/cache/npm ]; then echo NOACCESS to npm cache; exit 1;fi)
RUN [ -w /usr/local/lib/node_modules ] || (echo NOACCESS to npm lib && exit 1)

# Globally install (in /usr/local/lib/node_modules) popular packages
# Allow intermediate layers, growup by steps
RUN npm install -g\
    grunt-cli \
    grunt-init \
    bower \
    requirejs

RUN npm install -g \
    yo \
    generator-webapp

CMD ["/bin/bash"]
