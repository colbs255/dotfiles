# syntax=docker/dockerfile:1
# Run from the docker folder
   
FROM alpine:3.17

WORKDIR /root
COPY ../ ./dotfiles

# Install packages
RUN apk update \
    && apk upgrade \
    && xargs apk add <dotfiles/linux-docker/packages.txt

# Install dotfiles
RUN cd dotfiles \
    && stow nvim \
    && stow fish

CMD ["fish"]
