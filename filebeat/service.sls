# filebeat 1.0.0 will not start without tty. use_vt in cmd.run, or sudo with !requiretty in sudoers (default) does not work.
# this is a hack to get around that issue. 
filebeat.sshkeygen:
  cmd.run:
    - name: ssh-keygen -f /root/.ssh/filebeat -P ""
    - unless: 
      - ls /root/.ssh/filebeat

filebeat.pubkeytoauth:
  cmd.run:
    - name: cat /root/.ssh/filebeat.pub >> /root/.ssh/authorized_keys
    - unless: cat /root/.ssh/filebeat.pub | grep -f - /root/.ssh/authorized_keys
    - require:
      - cmd: filebeat.sshkeygen

filebeat.service:
  cmd.run:
    - name: ssh -t -t -o NoHostAuthenticationForLocalhost=yes -i /root/.ssh/filebeat root@localhost "su -c 'service filebeat restart'"
    - require:
      - pkg: filebeat
      - cmd: filebeat.sshkeygen
      - cmd: filebeat.pubkeytoauth
