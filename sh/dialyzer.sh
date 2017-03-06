#!/bin/bash
# Program:
# 	dialyzer ipip-erlang
# 	dialyzer Log in /log/dialyzer.log
# history:
# 2017/03/06	beiping96@gmail.com	First release
dialyzer --check_plt || dialyzer --build_plt --apps kernel stdlib eunit
dialyzer ../ebin/*.beam -o ../log/dialyzer.log
