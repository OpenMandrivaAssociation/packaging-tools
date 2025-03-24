Summary:	Tools that make packagers' lives easier
Name:		packaging-tools
Version:	2.2.1
Release:	1
License:	Public Domain
Group:		Development/Other
Url:		https://openmandriva.org/
Source0:	e
Source1:	e.1
Source2:	vs
Source3:	vs.1
Source4:	vl
Source5:	vl.1
Source6:	vj
Source7:	vj.1
Source8:	vo
Source9:	vo.1
Source10:	vp
Source11:	vp.1
Source12:	vpl
Source13:	vpl.1
Source14:	vgo
Source15:	vgo.1
Source16:	build
Source17:	build.1
Source18:	b
Source19:	b.1
Source20:	packaging-tools.sh
Source21:	co.1
Source22:	xc
Source23:	xc.1
Source24:	add-to-om
BuildArch:	noarch
Requires:	abb
Requires:	abf-console-client
Requires:	git-core
# For gendiff
Requires:	rpm

%description
Some tools that make packagers' lives easier.

%prep

%build

%install
mkdir -p %{buildroot}%{_bindir} %{buildroot}%{_mandir}/man1 %{buildroot}%{_sysconfdir}/profile.d
install -c -m 755 %SOURCE0 %SOURCE2 %SOURCE4 %SOURCE6 %SOURCE8 %SOURCE10 %SOURCE12 %SOURCE14 %SOURCE16 %SOURCE18 %SOURCE22 %SOURCE24 %{buildroot}%{_bindir}/
install -c -m 644 %SOURCE1 %SOURCE3 %SOURCE5 %SOURCE7 %SOURCE9 %SOURCE11 %SOURCE13 %SOURCE15 %SOURCE17 %SOURCE19 %SOURCE21 %SOURCE23 %{buildroot}%{_mandir}/man1/
install -c -m 644 %SOURCE20 %{buildroot}%{_sysconfdir}/profile.d/99packaging-tools.sh

%files
%{_bindir}/*
%{_sysconfdir}/profile.d/99packaging-tools.sh
%{_mandir}/man1/*
