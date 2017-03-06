# ipip-erlang
http://ipip.net IP location

Convert `./priv/17monipdb.dat` To `./src/data_ip.erl`

Use Erlang version is [OTP 18.3](http://www.erlang.org/downloads/18.3)

## Usage
Step 1: Download

Step 2: Get `17monipdb.dat` from http://ipip.net

Step 3: Copy `17monipdb.dat` to `./priv/17monipdb.dat`

Step 4: Run `./sh/make.sh` to compile `./src/ipip.erl`

Step 5: Run `./sh/run.sh` to start Erlang shell

Step 6: Run `ipip:init().` to convert `data_ipip.erl`

Step 7: Run `./sh/make.sh` to compile `./src/data_ipip.erl`
