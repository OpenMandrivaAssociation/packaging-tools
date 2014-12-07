Summary:	Tools that make packagers' lives easier
Name:		packaging-tools
Version:	1.2
Release:	4
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
BuildArch:	noarch

%description
Some tools that make packagers' lives easier

%prep

%build

%install
mkdir -p %{buildroot}%{_bindir} %{buildroot}%{_mandir}/man1
install -c -m 755 %SOURCE0 %SOURCE2 %SOURCE4 %SOURCE6 %SOURCE8 %{buildroot}%{_bindir}/
install -c -m 644 %SOURCE1 %SOURCE3 %SOURCE5 %SOURCE7 %SOURCE9 %{buildroot}%{_mandir}/man1/

%files
%{_bindir}/*
%{_mandir}/man1/*

