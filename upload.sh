#!/bin/sh -e
##:
#h: Usage: ./upload.sh { [-n NAME][-d DESCRIPTION] TAGS | -V }
##:
upload_sh() {
    local OPTIND=1 optopt name= desc=
    while getopts "n:d:" optopt; do # OPTARG
        case $optopt in
            n)  name="${OPTARG}";;
            d)  desc="${OPTARG}";;
            \?) return 1;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if test ! -n "${name}"; then
        echo "error: Please specify a name." >&2
        return 1
    fi
    echo "gh_token    : ${DEVREAL_GH_TOKEN}"
    echo "name        : ${name}"
    echo "description : ${desc}"
    echo "tars        : $*"
    GH_TOKEN="${DEVREAL_GH_TOKEN}" gh release create --notes "${desc}" "${name}" "$@"
}
# --------------------------------------------------------------------
: ${DEVREAL_GH_TOKEN:=${GH_TOKEN}}
if test @"${0##*/}" = @"upload.sh"; then
    export MSYS_NO_PATHCONV=1
    case "${1}" in
        ''|-h|--help) sed -n 's/^ *#h: \{0,1\}//p' "$0";;
        -V)  echo "DEVREAL_GH_TOKEN : ${DEVREAL_GH_TOKEN}"; exit 0;;
        *)   upload_sh "$@"; exit 0;;
    esac
fi
