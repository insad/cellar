#!/bin/bash

BUILD='docker build -t ember-cli/base/app:2.8LTS .'

echo
echo "<Ember-cli> $BUILD"
echo

$BUILD
