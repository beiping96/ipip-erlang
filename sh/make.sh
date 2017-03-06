#!/bin/bash
# Program:
# 	Compile ipip-erlang
# history:
# 2017/03/06	beiping96@gmail.com	First release
erlc +debug_info -Wall -o ../ebin/ ../src/*
