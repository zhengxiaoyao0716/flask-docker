# flask - docker
### Docker image of python webapp.
Pre-installed uwsgi & supervisor, base on python:2.7-alpine
***
## -- File structure --
```
path/to/app
    - src  # Put your webapp(s) source code hear.
        -- static
        -- templates
        -- application.py
        -- src/.uwsgi.ini
        ...
        # Folder|module is permitted hear for more then one app.
        -- app1
            ...
        -- app2
            ...
        ...
    - share  # Used to share with host|other-contains.
        -- static/...  # Convenience to service static files by nginx.
        -- tmp/.uwsgi.sock  # Convenience to connect.
        -- app3  # Convenience to develop and debug.
        ...
    - programs.conf  # Config-file for supervisor.
    - requirements.txt  # Install your dependencies.
```
- You can get help from http://supervisord.org/running.html#adding-a-program to see how to write "programs.conf".
- Notice, if your python webapp is deployed based on uwsgi,<br />
you must add 'plugins = /usr/lib/uwsgi/python' to it's config file:<br />
 - src/.uwsgi.ini
> [uwsgi]<br />
> ...<br />
> plugins = /usr/lib/uwsgi/python<br />
> socket = /web/share/%n.sock<br />
> chmod-socket = 666<br />
> ...

***
## -- Build image --
##### First, add your "Dockerfile":
```
FROM zhengxiaoyao0716/flask

MAINTAINER ${your name}

EXPOSE  port1 port2 ...
``` 
##### Now, you can build your webapp image:
```
docker build -t <yourImageName> .
``` 
***

## -- Start container --
```
docker run --name <appName> \
    -p <host-port>:<port> \
    -v <volumeDir>:/web/share \
    -d <yourImageName>
```
- --name=                     Assign a name to the container
- -p, --publish=[]            Publish a container's port(s) to the host
- -v, --volume=[]             Bind mount a volume
- -d, --detach=false          Run container in background and print container ID

Now your container will running in background.
##### Maybe you need to enter it:
```
docker exec -it <appName> /bin/sh
```