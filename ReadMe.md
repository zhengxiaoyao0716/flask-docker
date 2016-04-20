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
        ...
        # Folder|module is permitted hear for more then one app.
        -- app1
            ...
        -- app2
            ...
        ...
    - share  # Used to share with host|other-contains.
        -- tmp/uwsgi.sock  # Convenience to connect.
        -- app3  # Convenience to develop and debug.
        ...
    - programs.conf  # Config-file for supervisor.
    - requirements.txt  # Install your dependencies.
```
- You can get help from http://supervisord.org/running.html#adding-a-program to see how to write "programs.conf".

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