FROM alpine:3.18.4

# Installs shell related tools
RUN apk --no-cache add sudo tini shadow bash \
# Installs compatibility libs
  gcompat libc6-compat libgcc libstdc++ \
# Installs some basic tools
  git curl socat openssh-client nano unzip brotli zstd xz

# Installs "older" node-16 and npm-8
# Hack: to install such versions, we use repository from previous Alpine (3.16)
RUN sed -i 's/17/16/g' /etc/apk/repositories && \
    apk --no-cache add nodejs=16.19.1-r0 npm=8.10.0-r0 && \
    sed -i 's/16/17/g' /etc/apk/repositories  
 
ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Add group and user
RUN addgroup $USERNAME -g $USER_GID && \
    adduser -G $USERNAME -u $USER_UID -s /bin/bash -D $USERNAME && \
    echo $USERNAME ALL=\(ALL\) NOPASSWD:ALL > /etc/sudoers.d/nopasswd

# Change user
USER $USERNAME

# Configure a nice terminal
RUN echo "export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/$USERNAME/.bashrc && \
# Fake poweroff (stops the container from the inside by sending SIGHUP to PID 1)
    echo "alias poweroff='kill -1 1'" >> /home/$USERNAME/.bashrc

WORKDIR /home/$USERNAME
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/bash"]
