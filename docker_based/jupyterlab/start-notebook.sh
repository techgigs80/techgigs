#!/bin/bash
# Copyright (c) lucas.ku(ruria80@gmail.com)
# Distributed under the terms of the Modified BSD License.

set -e

. /usr/local/bin/start.sh jupyter lab "$@"

# jupyter notebook 2>~/jupyter.log
