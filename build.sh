#!/bin/sh

# docker build -t weblogic-gp-wdds:12.1.3 .
docker build -t giodocker/weblogic:12.2.1.4 .
# docker build --build-arg CUSTOM_DOMAIN_NAME=generic_domain -t weblogic-gp-generic:12.1.3 .
