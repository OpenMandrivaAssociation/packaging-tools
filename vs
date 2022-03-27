#!/bin/bash

SNAPSHOT=false
CMAKE=false
MESON=false
while [ "`echo $1 |cut -b1`" = "-" ]; do
	case "$1" in
	-s|--snapshot)
		SNAPSHOT=true
		;;
	-c|--cmake)
		CMAKE=true
		;;
	-m|--meson)
		MESON=true
		;;
	esac
	shift
done

NAME=`echo $1 |sed -e "s/\.spec$//"`
[ -z "$EDITOR" ] && EDITOR="$VISUAL"
if [ -z "$EDITOR" ]; then
	if [ -e /usr/bin/vim ]; then
		EDITOR=/usr/bin/vim
	fi
fi
ID="`cat /etc/passwd |grep "^$(id -un):" |cut -d: -f5` <`id -un`@`hostname |cut -d. -f2-`>"
[ -e ~/.vs ] && source ~/.vs
[ -z "$ABFDIR" ] && ABFDIR=~/abf

mkdir -p "$ABFDIR/$NAME"
cd "$ABFDIR/$NAME"
if [ ! -e "$NAME.spec" ]; then
	if $SNAPSHOT; then
		cat >"$NAME.spec" <<EOF
%define beta %{nil}
%define scmrev %{nil}

EOF
	fi
	cat >>"$NAME.spec" <<EOF
Name: $NAME
Version:
EOF

	if $SNAPSHOT; then
		cat >>"$NAME.spec" <<EOF
%if "%{beta}" == ""
%if "%{scmrev}" == ""
Release: 1
Source0: %{name}-%{version}.tar.xz
%else
Release: 0.%{scmrev}.1
Source0: %{name}-%{scmrev}.tar.xz
%endif
%else
%if "%{scmrev}" == ""
Release: 0.%{beta}.1
Source0: %{name}-%{version}%{beta}.tar.xz
%else
Release: 0.%{beta}.0.%{scmrev}.1
Source0: %{name}-%{scmrev}.tar.xz
%endif
%endif
EOF
	else
		cat >>"$NAME.spec" <<EOF
Release: 1
Source0: https://github.com/$NAME/$NAME/archive/%{version}/%{name}-%{version}.tar.gz
EOF
	fi

	cat >>"$NAME.spec" <<EOF
Summary:
URL: https://github.com/$NAME/$NAME
License: GPL
Group:
EOF
	$CMAKE && echo 'BuildRequires: cmake ninja' >>"$NAME.spec"
	$MESON && echo 'BuildRequires: meson ninja' >>"$NAME.spec"
	cat >>"$NAME.spec" <<EOF

%description

%prep
EOF

	if $SNAPSHOT; then
		cat >>"$NAME.spec" <<EOF
%autosetup -p1 -n %{name}%{!?scmrev:-%{version}%{?beta:%{beta}}}
EOF
	else
		echo '%autosetup -p1' >>"$NAME.spec"
	fi
	if $CMAKE; then
		echo "%cmake -G Ninja" >>"$NAME.spec"
	elif $MESON; then
		echo "%meson" >>"$NAME.spec"
	else
		echo "%configure" >>"$NAME.spec"
	fi
	if $CMAKE || $MESON; then
		BUILDTOOL=ninja
		MAKEARGS="$MAKEARGS -C build"
	else
		BUILDTOOL=make
	fi
	cat >>"$NAME.spec" <<EOF

%build
%${BUILDTOOL}_build$MAKEARGS

%install
%${BUILDTOOL}_install$MAKEARGS

%files
# Leaving the "/" in here is _BAD_, but will generally work [packaging all
# files] for testing.
# Please replace it with an actual file list to prevent your package from
# owning all system directories.
/
EOF
fi
exec "$EDITOR" "$NAME".spec
