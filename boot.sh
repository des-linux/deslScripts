#!/bin/sh
SELF=`readlink -f ${0}`;
sRoot=${SELF%/*};
export ServerLoader=${ServerLoader:-${sRoot}/ServerLoader};

[ -e "${CONF_FOLDER}/DefaultEnv.sh" ] && . ${CONF_FOLDER}/DefaultEnv.sh

exec ${BIN_FOLDER}/DESLService

