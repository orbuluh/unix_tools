#!/bin/sh

while : ;do
    read -p "Do you really want to do this? [y/n] " RESPONSE < /dev/tty
    case "${RESPONSE}" in
        [Yy]* ) break;;
        [Nn]* ) exit 1;;
    esac
done

echo "alright ... doing..."