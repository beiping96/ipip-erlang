# ipip-erlang
http://ipip.net IP location

Generate `./priv/17monipdb.dat` To `./src/data_ip.erl`

## Beforehand
Use Erlang version is [OTP 18.3](http://www.erlang.org/downloads/18.3)

Use Rebar version is [rebar3](http://www.rebar3.org/)

## How To Use It
Step 1: Download And Compile
```
git clone https://github.com/beiping96/ipip-erlang.git
rebar3 compile
```
Step 2: Get `17monipdb.dat` From http://ipip.net

Step 3: Move `17monipdb.dat` To `./priv/17monipdb.dat`

Step 4: Run Erlang Shell In `ipip.beam` Directory

Step 5: Run `ipip:init().` To Generate `data_ipip.erl`

Step 6: Compile `data_ipip.erl`


