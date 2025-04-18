#!/usr/bin/env bash
set -eu -o pipefail

# Remove small primes from the SSH moduli file
MODULI_FILE="/etc/ssh/moduli"
if [ -f "${MODULI_FILE}" ]; then
    echo "Removing small primes from ${MODULI_FILE}"
    awk '$5 > 3000' "${MODULI_FILE}" >"${HOME}/moduli"
    wc -l "${HOME}/moduli"
    sudo mv -f "${HOME}/moduli" "${MODULI_FILE}"
    sudo chown root:root "${MODULI_FILE}"
    sudo chmod 644 "${MODULI_FILE}"
    echo "Removed small primes from ${MODULI_FILE}"
else
    echo "${MODULI_FILE} does not exist"
fi
