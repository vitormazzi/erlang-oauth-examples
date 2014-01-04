#!/bin/sh
HOSTNAME=`hostname`
cd `dirname $0`
exec erl -sname $HOSTNAME -pa ebin -s crypto -s inets -s ssl
