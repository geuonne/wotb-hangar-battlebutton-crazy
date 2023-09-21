#!/bin/sh

e_inval=100
e_nodata=101

language_code="$1" && shift

if ! [ -t 0 ] ; then
	_input="$(cat)"
elif [ -n "$1" ] ; then
	_input="$*"
else
	echo 1>&2 "Error: no input data provided" && return "${e_nodata}"
fi

# Write your language alphabet here.
# The alphabet must be written in form '[:lower:]@[:upper:]'.
#shellcheck disable=SC2034
case "${language_code}" in
    en)      ALPHABET_src='abcdefghijklmnopqrstuvwxyz@ABCDEFGHIJKLMNOPQRSTUVWXYZ' ;;
    ru)      ALPHABET_src='абвгдеёжзийклмнопрстуфхцчшщьыъэюя@АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ' ;;
	uk)      ALPHABET_src='абвгґдеєжзиіїйклмнопрстуфхцчшщьюя@АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ' ;;
    **)      echo "Error: invalid language code" 1>&2 && return "${e_inval}" ;;
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
${_input}
EOF
