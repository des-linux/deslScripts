#!/bin/sh

add_path(){
	PATH="${PATH}:/usr/local${1}:/usr${1}:${1}";
	return 0;
}

set_env(){
	PATH='';
	add_path /sbin
	add_path /bin

	export PATH="${PATH:1}";
	export PS1='\u@\H \$ \w>';

	return 0;
}

Config(){
	# Set default env
	set_env;

	# Support core tools
	export PATH="${PATH}:/mnt/coretools0/sbin/:/mnt/coretools0/bin/";

	return 0;
}

Config;

