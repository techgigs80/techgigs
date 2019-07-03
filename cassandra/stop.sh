#!/bin/bash

nodetool disablegossip
sleep 3
nodetool disablethrift
sleep 3
nodetool drain
sleep 3
stop-server
