#!/usr/bin/env bash
# Tests de fonctions uniquement : aucun sudo, paquet ou service.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
source scripts/ssh_setup.sh
count=0
accept() {
  validate_network "$1" "$2" || { printf 'Refus inattendu : %s %s\n' "$1" "$2" >&2; exit 1; }
  count=$((count + 1))
}
reject() {
  if validate_network "$1" "$2"; then
    printf 'Acceptation inattendue : %s %s\n' "$1" "$2" >&2
    exit 1
  fi
  count=$((count + 1))
}
accept 192.168.1.50 192.168.1.0/24
accept 10.0.0.1 10.0.0.0/8
accept 172.31.255.254 172.16.0.0/12
accept 192.168.1.1 192.168.1.0/30
reject 192.168.1.0 192.168.1.0/24
reject 192.168.1.255 192.168.1.0/24
reject 192.168.2.1 192.168.1.0/24
reject 192.168.1.1 192.168.1.5/24
reject 192.168.1.1 192.0.0.0/8
reject 172.16.0.1 172.0.0.0/8
reject 8.8.8.8 8.0.0.0/8
reject 127.0.0.1 127.0.0.0/8
reject 192.168.1.1 0.0.0.0/0
reject 192.168.1.1 192.168.1.1/32
reject 192.168.1.1 192.168.1.0/31
reject 192.168.001.1 192.168.1.0/24
reject 192.168.1.256 192.168.1.0/24
reject '192.168.1.1;true' 192.168.1.0/24
reject ::1 ::/0
reject 192.168.1.1 '192.168.1.0/24 extra'
account=alice address=192.168.1.50 network=192.168.1.0/24
config=$(write_config)
for line in 'AllowUsers alice@192.168.1.0/24' 'ListenAddress 192.168.1.50' \
  'PermitRootLogin no' 'AddressFamily inet' 'PasswordAuthentication yes' \
  'PubkeyAuthentication yes' 'Subsystem sftp internal-sftp'; do
  [[ $'\n'"$config"$'\n' == *$'\n'"$line"$'\n'* ]] || { printf 'Directive absente : %s\n' "$line" >&2; exit 1; }
done
[[ ! $config =~ (^|$'\n')Include[[:space:]] ]] || exit 1
printf '%s cas réseau et génération de configuration : OK\n' "$count"
