Summary:	Tools that make packagers' lives easier
Name:		packaging-tools
Version:	2.1.2
Release:	1
License:	Public Domain
Group:		Development/Other
Url:		http://openmandriva.org/
Source0:	e
Source1:	e.1
Source2:	vs
Source3:	vs.1
Source4:	vl
Source5:	vl.1
Source6:	vj
Source7:	vj.1
Source8:	vp
Source9:	vp.1
Source10:	vpl
Source11:	vpl.1
Source12:	build
Source13:	build.1
Source14:	b
Source15:	b.1
Source16:	packaging-tools.sh
Source17:	co.1
BuildArch:	noarch
Requires:	abb
Requires:	abf-console-client
Requires:	git-core
# For gendiff
Requires:	rpm

%description
Some tools that make packagers' lives easier

%prep

%build

%install
mkdir -p %{buildroot}%{_bindir} %{buildroot}%{_mandir}/man1 %{buildroot}%{_sysconfdir}/profile.d
install -c -m 755 %SOURCE0 %SOURCE2 %SOURCE4 %SOURCE6 %SOURCE8 %SOURCE10 %SOURCE12 %SOURCE14 %{buildroot}%{_bindir}/
install -c -m 644 %SOURCE1 %SOURCE3 %SOURCE5 %SOURCE7 %SOURCE9 %SOURCE11 %SOURCE13 %SOURCE15 %SOURCE17 %{buildroot}%{_mandir}/man1/
install -c -m 644 %SOURCE16 %{buildroot}%{_sysconfdir}/profile.d/99packaging-tools.sh

%files
%{_bindir}/*
%{_sysconfdir}/profile.d/99packaging-tools.sh
%{_mandir}/man1/*
