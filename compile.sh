#! /bin/bash
sed -e 's/#.*$//' -e 's/ //g' -e '/^\s*$/d' src/dmap.evm | tr -d '\n'
