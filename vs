#!/bin/bash
# Spec file generator
# (c) 2000-2024 Bernhard Rosenkraenzer <bero@lindev.ch>

SNAPSHOT=false
while [ "`echo $1 |cut -b1`" = "-" ]; do
	case "$1" in
	-s|--snapshot)
		SNAPSHOT=true
		;;
	-a|--autotools|--autoconf)
		BUILDSYS=autotools
		;;
	-b|--buildsys)
		shift
		BUILDSYS="$1"
		;;
	-c|--cmake)
		BUILDSYS=cmake
		;;
	-C|--custom-buildsys)
		BUILDSYS=custom
		;;
	-m|--meson)
		BUILDSYS=meson
		;;
	esac
	shift
done

[ -z "$BUILDSYS" ] && BUILDSYS=cmake

case $BUILDSYS in
autotools)
	BSDEP="autoconf automake slibtool"
	;;
custom)
	BSDEP=""
	;;
*)
	BSDEP="$BUILDSYS"
	;;
esac

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
Name:		$NAME
Version:	
EOF

	if $SNAPSHOT; then
		cat >>"$NAME.spec" <<EOF
%if "%{beta}" == ""
%if "%{scmrev}" == ""
Release:	1
Source0:	%{name}-%{version}.tar.xz
%else
Release:	0.%{scmrev}.1
Source0:	%{name}-%{scmrev}.tar.xz
%endif
%else
%if "%{scmrev}" == ""
Release:	0.%{beta}.1
Source0:	%{name}-%{version}%{beta}.tar.xz
%else
Release:	0.%{beta}.0.%{scmrev}.1
Source0:	%{name}-%{scmrev}.tar.xz
%endif
%endif
EOF
	else
		cat >>"$NAME.spec" <<EOF
Release:	1
Source0:	https://github.com/$NAME/$NAME/archive/%{version}/%{name}-%{version}.tar.gz
EOF
	fi

	cat >>"$NAME.spec" <<EOF
Summary:	
URL:		https://github.com/$NAME/$NAME
License:	GPL
Group:		
EOF
	[ -n "$BSDEP" ] && echo "BuildRequires:	$BSDEP" >>"$NAME.spec"
	[ "$BUILDSYS" != "custom" ] && echo "BuildSystem:	$BUILDSYS" >>"$NAME.spec"
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

	if [ "$BUILDSYS" = "custom" ]; then
		cat >>"$NAME.spec" <<EOF

%conf

%build
%make_build

%install
%make_install
EOF
	fi

	cat >>"$NAME.spec" <<EOF

%files
EOF
fi
exec "$EDITOR" "$NAME".spec
