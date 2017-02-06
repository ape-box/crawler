#!/bin/sh
cd $(dirname $(realpath $0))

ruby -Ilib:test test/all_tests.rb
