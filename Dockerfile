FROM erlang:onbuild
MAINTAINER Du XingRui "beiping96@gmail.com"
COPY src/ /data/ipip/
RUN cd /data/ipip/
RUN erl
