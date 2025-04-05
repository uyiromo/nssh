#!/bin/bash
set -eu
set -o pipefail

if [ -f /etc/debian_version ]; then
    sudo apt install automake autoconf libssl-dev
elif [ -f /etc/redhat-release ] || [ -f /etc/fedora-release ]; then
    sudo dnf install automake autoconf openssl-devel
else
    echo "Unsupported OS"
    exit 1
fi

git submodule update --init --recursive --force
git -C openssh-portable apply ../cipher.patch
git -C openssh-portable apply ../mac.patch
git -C openssh-portable apply ../port.patch

INSTALLDIR=/opt/nssh
sudo rm -rf ${INSTALLDIR}
sudo mkdir -p ${INSTALLDIR}
pushd openssh-portable >/dev/null
autoreconf
./configure --prefix=${INSTALLDIR}
make
sudo make install
popd >/dev/null

echo "*** version:"
${INSTALLDIR}/bin/ssh -V | pr -t -o2
echo "*** supported ciphers:"
${INSTALLDIR}/bin/ssh -Q cipher | pr -t -o2
echo "*** supported MACs:"
${INSTALLDIR}/bin/ssh -Q mac | pr -t -o2
