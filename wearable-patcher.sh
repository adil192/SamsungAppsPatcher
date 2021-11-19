#!/bin/bash

set -e

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

patchapk(){
  app="$1"
  
  # decompile app
  apktool install-framework "apks/${app}.apk" # not sure if this line is necessary
  apktool decode -f "apks/${app}.apk" -o "decompiled/${app}"

  cd "decompiled/$app"
    # Use dansimko's command to remove the samsung check
    cecho "GREEN" "    patching samsung check in ${app}"
    find . -type f -name "*.smali" -exec sed -i 's/sget-object \(v\|p\)\(.\+\), Landroid\/os\/Build;->\(MANUFACTURER\|BRAND\):Ljava\/lang\/String;/const-string \1\2, \"letitbeheardthisphoneistobetreatedasifitwereofabranddifferentfromtheonestartingwiths\"/g' "{}" \;
  
    # Use any patches we find that start with $app
    for patch in ../../"$app"_*.patch; do
      if [[ -f $patch ]]; then
        cecho "GREEN" "    patching ${app} with $(basename $patch)"
        patch -p0 -d . < "$patch"
      fi
    done
  cd ../../
  
  # rebuild apk (into the $app/dist directory)
  cecho "GREEN" "    rebuilding ${app}"
  apktool build "decompiled/$app" --use-aapt2
  
  # align to 4-byte boundary, thanks to gella1992
  # https://forum.xda-developers.com/t/app-mod-galaxy-wearable-patch-for-samsung-phones-with-custom-roms.4208143/post-85635133
  zipalign -f -p 4 "decompiled/${app}/dist/${app}.apk" "patched/${app}.apk"
  
  # sign patched apk
  cecho "GREEN" "    signing ${app}"
  apksigner sign --ks keystore.jks --ks-pass file:ks-pass.txt "patched/${app}.apk"
}



mkdir -p patched
mkdir -p decompiled

i=1
numapks=$(count apks/*.apk)

if [ -z "$1" ]; then
  rm -rf decompiled/*
  # iterate through all apks in the apks directory
  for file in apks/*.apk; do
    app=$(basename "${file%.apk}")
    
    cecho "GREEN" "[${i} / ${numapks}] patching ${app}"
    patchapk "$app"
    cecho "GREEN" "[${i} / ${numapks}] successfully patched ${app}"
    
    i=$((i+1))
  done

  echo 
  cecho "GREEN" 'Find all patched apps in the "patched" folder'
else
  app=$(basename "${1%.apk}")
  rm -rf decompiled/${app}
  
  if [ ! -f "apks/${app}.apk" ]; then
    cecho "RED" "Cannot find file: apks/${app}.apk"
    echo "Please make sure that the apk is in the apks directory."
  fi
  
  cecho "GREEN" "patching ${app}"
  patchapk "$app"
  cecho "GREEN" "successfully patched ${app}. Find it at patched/${app}.apk"
fi
