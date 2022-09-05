# coder-core

This is my opinionated attempt to build a "lightweight" docker image powerful enough to run [vscode remote containers](https://code.visualstudio.com/docs/remote/containers-tutorial) or to be used as a base image to create [docker container GitHub Actions](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action). 

The **not-that-lightweight** actually means that while [ubuntu:latest](https://hub.docker.com/_/ubuntu) is ~78MB, this image is ~90MB. Yes, this translates to **extra 12MB** compared to ubuntu, but the preinstalled tools are **by far** more comprehensive (see bellow).

# Features

1. Based on Alpine instead of Ubuntu. This translates to [musl being used instead of glib](https://wiki.musl-libc.org/functional-differences-from-glibc.html), but compatibility libraries are also preinstalled. 
2. Its is Alpine, but using **bash** instead of **ash**.
3. By using **tini**, we ensure that child processes are correctly reaped.
4. Default user **coder** and group **coder** using UID and GID = 1000, to ease volume-mapping permissions issues.
5. Passwordless, **sudo** support: easily install extra packages with apk (e.g, ```sh sudo apk add docker-cli  jq```) 
7. Preinstalled node (v18.6.0) and npm (8.10.0) !!!
8. Preinstalled tooling (git, curl, socat, openssh-client, nano, unzip, brotli, zstd, xz) !!!

# Guidelines that I follow
 - Whenever possible, install software directly from the Alpine repositories, i.e. use apk instead of downloading / manually installing them.
 - Keep it small: do not cross the 100MB image size boundary.
 - Multi arch (amd64 && arm64)

 # Usage

```sh
docker run -it ghcr.io/raonigabriel/coder-core:latest
coder@65dc49a66e7c:~$
```
 
## Creating your own derived image (Java example)

```Dockerfile
FROM ghcr.io/raonigabriel/coder-core:latest
# Installing Java and tools
RUN sudo apk --no-cache add maven gradle
# Setup env variables
ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
    MAVEN_HOME=/usr/share/java/maven-3 \
    GRADLE_HOME=/usr/share/java/gradle
```

---
## Licenses

[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)

---
## Disclaimer
* This code comes with no warranty. Use it at your own risk.
* I don't like Apple. Fuck off, fan-boys.
* I don't like left-winged snowflakes. Fuck off, code-covenant. 
* I will call my branches the old way. Long live **master**, fuck-off renaming.
