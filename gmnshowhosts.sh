#!/bin/bash
ip=10.8.0.6
ping -c 1 $ip &> /dev/null && echo $ip $(ssh gmn@$ip "hostname") || echo $ip down
ip=10.8.0.10
ping -c 1 $ip &> /dev/null && echo $ip $(ssh gmn@$ip "hostname") || echo $ip down
ip=10.8.0.14
ping -c 1 $ip &> /dev/null && echo $ip $(ssh gmn@$ip "hostname") || echo $ip down
ip=10.8.0.18
ping -c 1 $ip &> /dev/null && echo $ip $(ssh gmn@$ip "hostname") || echo $ip down
ip=10.8.0.22
ping -c 1 $ip &> /dev/null && echo $ip $(ssh gmn@$ip "hostname") || echo $ip down
ip=10.8.0.26
ping -c 1 $ip &> /dev/null && echo $ip $(ssh gmn@$ip "hostname") || echo $ip down
ip=10.8.0.30
ping -c 1 $ip &> /dev/null && echo $ip $(ssh gmn@$ip "hostname") || echo $ip down
