#!/bin/bash

# count taken from https://stackoverflow.com/a/57436073/
count() { echo $#; }

# cecho taken from https://stackoverflow.com/a/53463162/
cecho(){
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    # ... ADD MORE COLORS
    NC="\033[0m" # No Color

    printf "${!1}${2} ${NC}\n"
}


directory="${1:-patched}"
numapks=$(count "${directory}"/*.apk)

if (( $numapks <= 1 )); then
  cecho "RED" "Error: There are no patched apks in directory \"$directory\"."
  echo "Run ./wearable-patcher.sh if you haven't already done so.
Otherwise, you can specify another directory by running 
  ./wearable-installer.sh path/to/dir"
  exit
fi

echo "Waiting for adb to connect... Press Ctrl+C to cancel."
adb wait-for-device
echo "    - Done"
echo


i=1

for file in "${directory}"/*.apk; do
  _apk=$(basename $file) # remove the directory
  app="${_apk%.apk}" # remove the extension
  
  cecho "GREEN" "[${i} / ${numapks}] installing ${app}"
  
  adb install --no-incremental "${directory}/${app}.apk"
  
  i=$((i+1))
done
