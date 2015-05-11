#!/bin/bash

version=`ruby -Ilib -e 'require "crosstie/version"; puts Crosstie::VERSION'`
spec=crosstie.gemspec
gem=crosstie-$version.gem

rm -r $gem
gem build $spec
gem install $gem --local
mkdir -p tmp
cd tmp
pwd
ps aux | grep spring | awk '{print $2}' | xargs kill -9
rm -rf sandbox
crosstie resources
crosstie new sandbox
