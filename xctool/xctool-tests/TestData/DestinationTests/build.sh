#!/bin/bash

PROJECTS=(ios-iphone)

for project in ${PROJECTS[@]}; do
  target_name="${project}Tests"

  xcodebuild \
    -project $project/$project.xcodeproj \
    -scheme $project \
    -sdk iphonesimulator \
    -configuration Debug \
    -IDEBuildLocationStyle=Custom \
    -IDECustomBuildLocationType=RelativeToWorkspace \
    -IDECustomBuildIntermediatesPath=Build/Intermediates \
    -IDECustomBuildProductsPath=Build/Products

  # Output build settings, but strip out all but the first target.
  xcodebuild \
    -project $project/$project.xcodeproj \
    -scheme $project \
    -sdk iphonesimulator \
    -configuration Debug \
    -IDEBuildLocationStyle=Custom \
    -IDECustomBuildLocationType=RelativeToWorkspace \
    -IDECustomBuildIntermediatesPath=Build/Intermediates \
    -IDECustomBuildProductsPath=Build/Products \
    test \
    -showBuildSettings | \
    perl -E '$/ = undef; $str = <STDIN>; $str =~ s/Build settings for action test and target [^\s]+Tests:.*//s; print $str;' > ${project}-showBuildSettings.txt

  xcodebuild \
    -project $project/$project.xcodeproj \
    -target ${target_name} \
    -sdk iphonesimulator \
    -configuration Debug \
    -IDEBuildLocationStyle=Custom \
    -IDECustomBuildLocationType=RelativeToWorkspace \
    -IDECustomBuildIntermediatesPath=Build/Intermediates \
    -IDECustomBuildProductsPath=Build/Products \
    -showBuildSettings > ${project}-${target_name}-showBuildSettings.txt


done
