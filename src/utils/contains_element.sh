#!/bin/bash

# checks if an element is in the array
# Params:
#   $1 - item to match
#   $2 - array
contains_element() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && echo "true" && return; done
  echo "false"
}