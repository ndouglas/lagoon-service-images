#!/bin/bash
set -e

dind dockerd --insecure-registry=$OUTPUT_REGISTRY &

mkdir -p ~/.ssh

if [ ! -z "$SSH_PRIVATE_KEY" ]; then
  echo -e "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
  chmod 400 ~/.ssh/id_rsa

  eval $(ssh-agent) > /dev/null
  ssh-add ~/.ssh/id_rsa
fi

echo -e "Host * \n    StrictHostKeyChecking no" > ~/.ssh/config

exec "$@"
