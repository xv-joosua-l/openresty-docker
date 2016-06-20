#!/bin/sh

curl -L http://download.newrelic.com/agent_sdk/nr_agent_sdk-v${NR_SDK_VERSION}.x86_64.tar.gz | tar -C /opt -xzf - \
  && cp /opt/nr_agent_sdk-v${NR_SDK_VERSION}.x86_64/lib/*.so /lib/ \
  && rm -rf /opt/nr_agent_sdk-v${NR_SDK_VERSION}.x86_64/
