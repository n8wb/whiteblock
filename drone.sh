#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail


ssh-master () {
    ssh -i ~/.ssh/id_rsa ${SSH_USERNAME}@${SSH_HOST} "$@"
}


main () {
    if [[ -z ${DRONE:-} ]]; then
        echo This script is intended to be run by the Drone CI only
        return 1
    fi

    mkdir --parents ~/.ssh
    echo -n "$SSH_KEY_B64" | base64 --decode >~/.ssh/id_rsa
    echo "$SSH_HOST ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC4SRwCKg2jSv81mQcTp+n/UziKRGaa28ShIQWcFFqGakqIT3oPayzZ3QTJY0pw0bqajQf04h844mZWpJuECtU4=" >~/.ssh/known_hosts
    chmod --recursive go-rwx ~/.ssh

    ssh-master rm --recursive --force whiteblock
    ssh-master git clone https://github.com/rchain/whiteblock.git
    ssh-master "cd whiteblock && ./whiteblock.sh"
}


main "$@"
