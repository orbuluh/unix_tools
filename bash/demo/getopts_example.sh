#!/bin/bash

HELP_STR="usage: $0 [-h] [-o] [--optional_arg <value>] [--help]"

optspec=":oh-:" # Notes: `:` means "takes an argument", not "mandatory argument".
while getopts "$optspec" optchar; do
    case "${optchar}" in
    -) #e.g. the second '-'' out of --optional_arg or so
        case "${OPTARG}" in
        optional_arg)
            val="${!OPTIND}"
            OPTIND=$(($OPTIND + 1))
            optional_arg="${val}"
            ;;
        help)
            val="${!OPTIND}"
            OPTIND=$(($OPTIND + 1))
            ;;
        *)
            if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                echo "Found an unknown option --${OPTARG}" >&2
            fi
            ;;
        esac
        ;;
    o)
        val="${!OPTIND}"
        OPTIND=$(($OPTIND + 1))
        optional_arg="${val}"
        ;;
    h)
        echo "${HELP_STR}" >&2
        exit 2
        ;;
    *)
        if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
            echo "Error parsing short flag: '-${OPTARG}'" >&2
            exit 1
        fi

        ;;
    esac
done

if [ -z "$1" ]; then
    echo "${HELP_STR}" >&2
    exit 2
fi

echo "optional_arg=${optional_arg}!"

exit 0
