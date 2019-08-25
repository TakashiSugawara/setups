#!/bin/sh

set -eu

readonly SCRIPT_DIR=$(cd $(dirname ${0}) && pwd)
readonly PROJECT_DIR=$(cd ${SCRIPT_DIR}/../.. && pwd)
source ${SCRIPT_DIR}/export_envs.sh
source ${SCRIPT_DIR}/install_app.sh
source ${SCRIPT_DIR}/update_app.sh

# setup Python3 and Ansible
if [ $(uname) == 'Darwin' ]; then
    source ${SCRIPT_DIR}/macos.sh
elif [ $(expr substr $(uname -s) 1 5) == 'Linux' ]; then
    #TODO: add some cases for preprovisioning distributions.
    :
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

# install Poetry
installApp 'Poetry' 'poetry --version' 'POETRY_PREVIEW=1; curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python3'
exportEnvs 'export PATH="${PATH}:${HOME}/.poetry/bin"'
updateApp 'Poetry' 'poetry self update'
cd ${PROJECT_DIR} && poetry env use 3 && poetry install --no-dev && poetry update --no-dev

echo 'The pre-provisioning was done.'
