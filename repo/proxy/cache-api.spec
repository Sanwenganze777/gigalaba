Name:           cache-api
Version:        1.0
Release:        1%{?dist}
Summary:        Caching proxy API (Flask + Redis)
License:        MIT
BuildArch:      noarch
Source0:        cache-api.py
Source1:        config.yaml
Source2:        cache-api.service
Requires:       python3-flask, python3-redis, python3-requests, python3-pyyaml
%{?systemd_requires}

%description
Flask proxy that caches backend API responses in Redis.

%install
install -D -m 0755 %{SOURCE0} %{buildroot}/opt/cache-api/cache-api.py
install -D -m 0644 %{SOURCE1} %{buildroot}/etc/cache-api/config.yaml
install -D -m 0644 %{SOURCE2} %{buildroot}%{_unitdir}/cache-api.service

%post
systemctl daemon-reload >/dev/null 2>&1 || :

%files
/opt/cache-api/cache-api.py
%config(noreplace) /etc/cache-api/config.yaml
%{_unitdir}/cache-api.service
