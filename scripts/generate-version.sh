#!/bin/bash -xe

version=`cat pubspec.yaml | grep 'version: ' | cut -d ' ' -f 2`
contents="// This file is generated. Do not manually edit.\nString igniteVersion = '$version';\n"
echo "$contents" | sed 's/\\n/\n/g' > lib/version.g.dart