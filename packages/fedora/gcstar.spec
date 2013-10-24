Name:           gcstar
Version:        1.7.0
Release:        4%{?dist}
Summary:        Personal collections manager

Group:          Applications/Databases
License:        GPL
URL:            http://www.gcstar.org/
Source0:        http://download.gna.org/gcstar/gcstar-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch

BuildRequires:    desktop-file-utils
Requires:         perl-Gtk2

%define desktop_vendor fedora

%description
GCstar is an application for managing your personal collections.
Detailed information on each item can be automatically retrieved
from the internet and you can store additional data, depending on
the collection type. And also who you've lent your them to. You
may also search and filter your collection by criteria.

%prep
%setup -q -n gcstar


%build

%install
rm -rf %{buildroot}
%{__mkdir_p} %{buildroot}%{_prefix}
%{__install} -d %{buildroot}%{_bindir}
%{__install} bin/gcstar %{buildroot}%{_bindir}
%{__install} -d %{buildroot}%{_libdir}
%{__cp} -a lib/gcstar %{buildroot}%{_libdir}
%{__install} -d %{buildroot}%{_datadir}
%{__cp} -a share/gcstar %{buildroot}%{_datadir}
%{__install} -d %{buildroot}%{_mandir}/man1
%{__install} man/gcstar.1 %{buildroot}%{_mandir}/man1
gzip %{buildroot}%{_mandir}/man1/gcstar.1

# Install menu entry
%{__cat} > %{name}.desktop << EOF
[Desktop Entry]
Name=GCstar
Comment=Manage your collections
GenericName=Personal collections manager
Exec=gcstar
Icon=%{_datadir}/gcstar/icons/gcstar_64x64.png
Terminal=false
Type=Application
MimeType=application/x-gcstar
Categories=Application;Office;
Encoding=UTF-8
EOF

%{__mkdir_p} %{buildroot}%{_datadir}/applications
desktop-file-install \
    --vendor %{desktop_vendor} \
    --dir %{buildroot}%{_datadir}/applications  \
    %{name}.desktop

#Mime Type
%{__cat} > %{name}.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="application/x-gcstar">
                <comment>GCstar collection</comment>
                <glob pattern="*.gcs"/>
        </mime-type>
</mime-info>
EOF

%{__mkdir_p} %{buildroot}%{_datadir}/mime/packages
cp %{name}.xml %{buildroot}%{_datadir}/mime/packages


%clean
rm -rf %{buildroot}

%post
update-desktop-database &> /dev/null ||:
update-mime-database %{_datadir}/mime &> /dev/null || :

%postun
update-desktop-database &> /dev/null ||:
update-mime-database %{_datadir}/mime &> /dev/null || :

%files
%defattr(-,root,root)
%doc CHANGELOG README LICENSE
%{_libdir}/gcstar
%{_datadir}/gcstar
%{_mandir}/man1/gcstar.1.gz
%attr(0755,root,root) %{_bindir}/gcstar
%{_datadir}/applications/%{desktop_vendor}-%{name}.desktop
%{_datadir}/mime/packages/%{name}.xml

%changelog
* Sat Oct 28 2006 Tian <tian@c-sait.net> - 0.5.0-4
  - Re-creation of the module because of a problem with previous import
* Sun Oct 22 2006 Tian <tian@c-sait.net> - 0.5.0-3
  - Restored BuildRequires
* Sat Oct 21 2006 Tian <tian@c-sait.net> - 0.5.0-2
  - Changed desktop vendor
  - Removed desktop-file-utils and shared-mime-info from required
  - Fixed icon path in desktop file
* Sat Oct 21 2006 Tian <tian@c-sait.net> - 0.5.0-1
  - First Fedora Extras version.
