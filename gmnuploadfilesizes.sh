#!/bin/bash
while IFS= read -r line; do
    ls -lah $line
done < "$1"
