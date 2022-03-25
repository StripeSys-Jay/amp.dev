#!/bin/bash

#Check and create required files/dirs, if doesn't exists.

[ ! -d dist/static/samples ] && mkdir -p dist/static/samples
[ ! -d dist/static/files ] && mkdir -p dist/static/files
[ ! -f dist/static/samples ] && touch dist/static/samples/samples.json


