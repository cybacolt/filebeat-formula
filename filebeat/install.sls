{% if salt['grains.get']('osfullname') == 'Ubuntu' %}
filebeat_repo:
  pkgrepo.managed:
    - name: deb https://packages.elastic.co/beats/apt stable main
    - file: /etc/apt/sources.list.d/filebeat.list
    - gpgcheck: 1
    - key_url: https://packages.elastic.co/GPG-KEY-elasticsearch
    - require_in:
      - pkg: filebeat.install
    - watch_in:
      - pkg: filebeat.install
{% endif %}

filebeat.install:
  pkg.installed:
    - name: filebeat

