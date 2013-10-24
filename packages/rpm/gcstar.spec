# Initial spec file created by autospec ver. 0.8 with rpm 3 compatibility
Summary: GCstar, Collection manager
Name: gcstar
Version: 1.7.0
Release: 1
Group: Applications/Databases
License: GPL
Source: gcstar-%{version}.tar.gz
Requires: perl-Gtk2 >= 1.054
BuildRoot: %{_tmppath}/%{name}-root
URL: https://gna.org/projects/gcstar/
BuildArch: noarch

%description
GCstar - Application that can be used to manage some collections.

#%description -l fr
GCstar - Application permettant de gérer des collections.

%prep
#%setup -c RPM
%setup -q -n %{name}

%install
#%__cp -a . "${RPM_BUILD_ROOT-/}"
./install --prefix=${RPM_BUILD_ROOT}/usr/ >/dev/null


%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"

%files
%defattr(-,root,root)
/usr/lib/gcstar/
/usr/share/gcstar/
/usr/man/man1/gcstar.1.gz
%attr(0755,root,root) /usr/bin/gcstar

%changelog
* Tue Feb 08 2005 Tian <tian@c-sait.net>
- Initial spec file created by autospec ver. 0.8 with rpm 3 compatibility
