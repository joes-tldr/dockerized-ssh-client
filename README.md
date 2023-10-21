# Dockerized SSH Client

Ref: https://man7.org/linux/man-pages/man1/ssh.1.html

DockerHub: https://hub.docker.com/r/joestldr/ssh-client

GitHub: https://github.com/joestldr/dockerized-ssh-client

## TLDR; Sample usages:

### Interactive:

```bash
$ docker run \
    --name joestldr-ssh \
    --interactive --tty --rm \
  joestldr/ssh:v1.0.0 \
    root@10.0.1.1
```

### Mount `.ssh` folder:

```bash
$ docker run \
    --name joestldr-ssh \
    --interactive --tty --rm \
    --volume /home/user/.ssh:/ssh \
  joestldr/ssh:v1.0.0 \
    root@10.0.1.1
```

### Sample daemonized usage:

```bash
$ docker run \
    --name joestldr-ssh \
    --detach \
    --restart unless-stopped \
    --volume /home/user/.ssh:/ssh \
    --publish 0.0.0.0:22222:22222 \
    --publish 0.0.0.0:10080:10080 \
  joestldr/ssh:v1.0.0 \
    -vNT4 \
    -L 0.0.0.0:22222:192.168.56.99:22 \
    -D 0.0.0.0:10080 \
    root@10.0.1.1
```

# License

Copyright 2023 [joestldr](https://joestldr.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
