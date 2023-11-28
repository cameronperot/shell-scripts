#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

# setup
RELEASE="0.9.68"
INTEGRATE=${1:-true}
SOURCE_DIR=/tmp/firejail

sudo rm -rf ${SOURCE_DIR}
git clone https://github.com/netblue30/firejail.git ${SOURCE_DIR}
cd ${SOURCE_DIR}
git checkout ${RELEASE}

# build rpm
NAME=firejail
VERSION=$(grep "PACKAGE_VERSION=.*" configure | grep -oE "([[:digit:]]|\.)*")
COMMIT=$(git rev-parse --short HEAD)

installed_release=$(rpm -q --qf="%{RELEASE}" $NAME ||:)
echo $installed_release
if [ -z "$installed_release" ]; then
        RELEASE=1
elif [ "$installed_release" == "package firejail is not installed" ]; then
        RELEASE=2
else
        RELEASE=$(($(grep -oE "^[[:digit:]]+" <<<"$installed_release") + 1))
fi
echo $RELEASE

TOPDIR=$(mktemp -dt $NAME-build.XXXXXX)
BUILDDIR=$(rpm --define "_topdir $TOPDIR" --eval %_builddir)
RPMDIR=$(rpm --define "_topdir $TOPDIR" --eval %_rpmdir)
SOURCEDIR=$(rpm --define "_topdir $TOPDIR" --eval %_sourcedir)
SPECDIR=$(rpm --define "_topdir $TOPDIR" --eval %_specdir)
SRPMDIR=$(rpm --define "_topdir $TOPDIR" --eval %_srcrpmdir)

mkdir -p "$BUILDDIR" "$RPMDIR" "$SOURCEDIR" "$SPECDIR" "$SRPMDIR"

cleanup() {
        rm -rf "$TOPDIR"
}
trap cleanup EXIT

cat <<EOF > "$SPECDIR/$NAME.spec"
Name:           $NAME
Version:        $VERSION
Release:        $RELEASE.git$COMMIT%{?dist}
Summary:        Linux namespaces sandbox program

License:        GPLv2+
URL:            https://github.com/netblue30/firejail
Source0:        %{name}.tar.gz

Recommends:     xdg-dbus-proxy
BuildRequires:  libselinux-devel

%description
Firejail is a SUID sandbox program that reduces the risk of security
breaches by restricting the running environment of untrusted applications
using Linux namespaces. It includes a sandbox profile for Mozilla Firefox.


%prep
%autosetup -c


%build
%configure --enable-selinux
%make_build


%install
make install-strip DESTDIR=%{buildroot}


%files
%config(noreplace) %{_sysconfdir}/firejail/firejail.config
%config(noreplace) %{_sysconfdir}/firejail/login.users
%config %{_sysconfdir}/firejail/*.inc
%config %{_sysconfdir}/firejail/*.net
%config %{_sysconfdir}/firejail/*.profile
%{_bindir}/firecfg
%{_bindir}/firejail
%{_bindir}/firemon
%{_libdir}/firejail
%{_datadir}/bash-completion/completions/firejail
%{_datadir}/bash-completion/completions/firecfg
%{_datadir}/bash-completion/completions/firemon
%{_docdir}/firejail/COPYING
%{_docdir}/firejail/README
%{_docdir}/firejail/RELNOTES
%{_docdir}/firejail/profile.template
%{_docdir}/firejail/redirect_alias-profile.template
%{_docdir}/firejail/syscalls.txt
%{_mandir}/man1/firecfg.1.gz
%{_mandir}/man1/firejail.1.gz
%{_mandir}/man1/firemon.1.gz
%{_mandir}/man5/firejail-login.5.gz
%{_mandir}/man5/firejail-profile.5.gz
%{_mandir}/man5/firejail-users.5.gz
%{_datadir}/vim/vimfiles/ftdetect/firejail.vim
%{_datadir}/vim/vimfiles/syntax/firejail.vim
%license COPYING
EOF

tar --exclude-vcs-ignore --exclude="./.git" --exclude="./test" --create --gzip --file "$SOURCEDIR/$NAME.tar.gz" .

rpmbuild --nodebuginfo --quiet --define "_topdir $TOPDIR" -bb "$SPECDIR"/$NAME.spec

RPM="$NAME-$VERSION-$RELEASE.git$COMMIT$(rpm -E %{?dist}).$(rpm -E %_arch).rpm"

mv "$RPMDIR/$(rpm -E %_arch)/$RPM" .

sudo dnf install "$RPM"

rm "$RPM"

# integrate and clean up
if [ ${INTEGRATE} = 'true' ]; then
    firecfg --fix-sound
    sudo firecfg
fi

sudo rm -rf ${SOURCE_DIR}
