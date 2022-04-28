#cloud-config
users:
  - name: "${ ssh_admin_user }"
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: "${ ssh_admin_password_salted_hash }"
    ssh-authorized-keys:
%{ for ssh_key in ssh_keys ~}
      - ${ file(ssh_key) }
%{ endfor ~}
