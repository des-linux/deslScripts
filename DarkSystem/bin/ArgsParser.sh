#!INCLUDE_ONLY
#//////////////////////////////////////////////////
#//DESLinux Builder
#//     (C)2014-2022 Dark Embedded Systems.
#//     http://xprj.net/
#//////////////////////////////////////////////////

# ARGS_RAW_STRING	Args string	: "${@}" when called parse_args();
# ARGS_OPT_LONG_	Long option	: --long-option(=value)
#			DES option	: /option(:value)
# ARGS_OPT_SHORT_	Short option	: -s(=value)
# ARGS_OPT_N_		+number option	: -n(0)
# ARGS_VALUE_		value override	: key=value
#
# ARGS_FIRST_CMD	mode selector	: First 'ARGS_OPT_LONG_' key that do not have value
# ARGS_TARGET		target selector	: 'make' style target (mode) selector
#					  (First 'ARGS_VALUE_' key that do not have value)

# If value is omitted, will set '-' as value.

parse_args_key_convdb(){
cat <<"EOF";
 	20
!	21
\*	2A
+	2B
,	2C
-	2D
.	2E
\/	2F
:	3A
\?	3F
@	40
EOF
}

parse_args_key_encode(){ # ValNameToReturn, (Key)
	[ "${1}" = '' ] && return 1;
	eval local _KEY_CVT_=\${2:-\${${1}}};
	local _VAL_CVT_=${1};

	local IFS=$'\n\r';
	for x in `parse_args_key_convdb`; do
		IFS=$'\t';
		set -- ${x}
		eval _KEY_CVT_=\${_KEY_CVT_//${1}/__0x${2}__};
	done


	eval ${_VAL_CVT_}=\"${_KEY_CVT_}\";

	return 0;
}

parse_args_key_decode(){ # ValNameToReturn, (Key)
	[ "${1}" = '' ] && return 1;
	eval local _KEY_CVT_=\${2:-\${${1}}};
	local _VAL_CVT_=${1};

	local IFS=$'\n\r';
	for x in `parse_args_key_convdb`; do
		IFS=$'\t';
		set -- ${x}
		eval _KEY_CVT_=\${_KEY_CVT_//__0x${2}__/${1}};
	done

	eval ${_VAL_CVT_}=\"${_KEY_CVT_}\";

	return 0;
}

parse_args(){
	local A KEY VAL;
	local OFS=${IFS};
	local IFS=${OFS};

	export ARGS_RAW_STRING="${@}";
	export ARGS_TARGET='';
	export ARGS_FIRST_CMD='';
	export ARGS_FIRST_CMD_EX='';

	for A in "${@}"; do
		case "${A}" in 
			/*:*)
				A="${A:1}";
				K="${A%%:*}";
				V="${A#*:}";
				eval ARGS_OPT_LONG_${K//-/_}="\"${V}\"";
				continue;;
			/*)
				A="${A:1}";
				eval ARGS_OPT_LONG_${A//-/_}='-';
				[ "${ARGS_FIRST_CMD}" = '' ] && ARGS_FIRST_CMD=${A};
				[ "${ARGS_FIRST_CMD_EX}" = '' ] && [ "${A:3}" != '' ] && ARGS_FIRST_CMD_EX=${A};
				continue;;

			--*=*)
				A="${A:2}";
				K="${A%%=*}";
				V="${A#*=}";
				eval ARGS_OPT_LONG_${K//-/_}="\"${V}\"";
				continue;;

			--*)
				A="${A:2}";
				eval ARGS_OPT_LONG_${A//-/_}='-';
				[ "${ARGS_FIRST_CMD}" = '' ] && ARGS_FIRST_CMD=${A};
				[ "${ARGS_FIRST_CMD_EX}" = '' ] && [ "${A:3}" != '' ] && ARGS_FIRST_CMD_EX=${A};
				continue;;

			-*=*)
				K="${A:1:1}";
				V="${A:2}";
				eval ARGS_OPT_SHORT_${K//-/_}="\"${V:--}\"";
				continue;;

			-*)
				K="${A:1:1}";
				V="${A:2}";
				eval ARGS_OPT_N_${K//-/_}=${V};
				continue;;

			*=*)
				K="${A%%=*}";
				V="${A#*=}";
				K="${K//-/_}";
				parse_args_key_encode K
				eval ARGS_VALUE_${K}="\"${V}\"";
				continue;;

			*)
				parse_args_key_encode A "${A//-/_}"
				eval ARGS_VALUE_${A}='-';

				[ "${ARGS_TARGET}" = '' ] && ARGS_TARGET=${A};
				continue;;
		esac

	done

	return 0;
}

