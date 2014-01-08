#!/bin/bash

SNAPSHOT=false
if [ "$1" = "-s" -o "$1" = "--snapshot" ]; then
	shift
	SNAPSHOT=true
fi

NAME=`echo $1 |sed -e "s/\.spec$//"`
[ -z "$EDITOR" ] && EDITOR="$VISUAL"
if [ -z "$EDITOR" ]; then
	if [ -e /usr/bin/vim ]; then
		EDITOR=/usr/bin/vim
	else
		EDITOR=/bin/vi
	fi
fi
ID="`cat /etc/passwd |grep "^$(id -un):" |cut -d: -f5` <`id -un`@`hostname |cut -d. -f2-`>"
[ -e ~/.vs ] && source ~/.vs

if [ ! -e ~/rpmbuild/SPECS/$NAME.spec ]; then
	if $SNAPSHOT; then
		cat >~/rpmbuild/SPECS/$NAME.spec <<EOF
%define beta %{nil}
%define scmrev %{nil}

EOF
	fi
	cat >>~/rpmbuild/SPECS/$NAME.spec <<EOF
Name: $NAME
Version:
EOF

	if $SNAPSHOT; then
		cat >>~/rpmbuild/SPECS/$NAME.spec <<EOF
%if "%{beta}" == ""
%if "%{scmrev}" == ""
Release: 1
Source0: %{name}-%{version}.tar.bz2
%else
Release: 0.%{scmrev}.1
Source0: %{name}-%{scmrev}.tar.xz
%endif
%else
%if "%{scmrev}" == ""
Release: 0.%{beta}.1
Source0: %{name}-%{version}%{beta}.tar.bz2
%else
Release: 0.%{beta}.0.%{scmrev}.1
Source0: %{name}-%{scmrev}.tar.xz
%endif
%endif
EOF
	else
		cat >>~/rpmbuild/SPECS/$NAME.spec <<EOF
Release: 1
Source0: %{name}-%{varsion}.tar.xz
EOF
	fi

	cat >>~/rpmbuild/SPECS/$NAME.spec <<EOF
Summary:
URL: http://$NAME.sf.net/
License: GPL
Group:

%track
prog %{name} = {
	url = http://
	regex = "version (__VER__)"
	version = %{version}
}

%description

%prep
EOF

	if $SNAPSHOT; then
		cat >>~/rpmbuild/SPECS/$NAME.spec <<EOF
%if "%{scmrev}" == ""
%setup -q -n %{name}-%{version}%{beta}
%else
%setup -q -n %{name}
%endif
EOF
	else
		echo '%setup -q' >>~/rpmbuild/SPECS/$NAME.spec
	fi
	cat >>~/rpmbuild/SPECS/$NAME.spec <<EOF
%configure

%build
%make

%install
%makeinstall_std

%files
# Leaving the "/" in here is _BAD_, but will generally work [packaging all
# files] for testing.
# Please replace it with an actual file list to prevent your package from
# owning all system directories.
/
EOF
fi
exec "$EDITOR" ~/rpmbuild/SPECS/"$NAME".spec
