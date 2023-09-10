#!/bin/sh

set -e

language_code="$1" && shift

# Write your language alphabet here.
# The alphabet must be written in form '[:lower:]@[:upper:]'.
#shellcheck disable=SC2034
case "${language_code}" in
    en)      ALPHABET_src='abcdefghijklmnopqrstuvwxyz@ABCDEFGHIJKLMNOPQRSTUVWXYZ' ;;
    ru)      ALPHABET_src='абвгдеёжзийклмнопрстуфхцчшщьыъэюя@АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ' ;;
	uk)      ALPHABET_src='абвгґдеєжзиіїйклмнопрстуфхцчшщьюя@АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ' ;;
    **)      false ;;
esac

ALPHABET_rev="$(rev <<EOF
${ALPHABET_src}
EOF
)"

ALPHABET_rev="$(sed 's/\([^@]*\)@\(.*\)/\2@\1/' <<EOF
${ALPHABET_rev}
EOF
)"



sed "y/${ALPHABET_src}/${ALPHABET_rev}/" <<-EOF
$@
EOF

set +e
