FROM node
MAINTAINER RockyRoad
LABEL version="0.1.0"
LABEL variant="dev"

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    man \
    less \
    tree \
    vim    

ARG USER1=user1
RUN useradd -ms /bin/bash -Uu 1000 -G staff $USER1

# Allow cache persistence:
#RUN echo cache = /var/local/cache/npm > /usr/local/etc/npmrc
ADD etc/* /usr/local/etc/
RUN mkdir -p /var/local/cache
ADD cache/* /var/local/cache
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
VOLUME /home/$USER1/node-projects
VOLUME /var/local/cache
# IPC
EXPOSE 8080 8081 8082
# for livereload - TESTME
EXPOSE 35729

# Check write access for npm before starting the downloads ...
RUN (if [ ! -w /var/local/cache/npm ]; then echo NOACCESS to npm cache; exit 1;fi)
RUN [ -w /usr/local/lib/node_modules ] || (echo NOACCESS to npm lib && exit 1)

# Globally install (in /usr/local/lib/node_modules) popular packages
# Broken down to steps for debugging
RUN npm ls -l -g > npmls-g.0 
RUN npm install -g\
    grunt-cli \
    grunt-init 
RUN npm ls -l -g > npmls-g.1

RUN npm install -g\
    bower 
RUN npm ls -l -g > npmls-g.2 

RUN npm install -g\
    requirejs
RUN npm ls -l -g > npmls-g.3

CMD ["/bin/bash"]
