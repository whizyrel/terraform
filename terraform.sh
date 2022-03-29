#!/bin/bash

TERRAFORM_VERSION=$2
DEFAULT_VERSION=1.1.7

if [ "$1" == '' ]
then
    echo 'No Root Password provided';
    exit 127
fi

if [ "$2" == '' ]
then
    echo 'No version specified using '"$DEFAULT_VERSION";
    TERRAFORM_VERSION=$DEFAULT_VERSION
fi

curl -fsSL https://apt.releases.hashicorp.com/gpg > gpg && set -ex | echo $1 | sudo -S apt-key add gpg && rm gpg
set -ex | echo $1 | sudo -S apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
set -ex | echo $1 | sudo -S apt-get update && sudo apt install -y terraform=$TERRAFORM_VERSION
exit 0
