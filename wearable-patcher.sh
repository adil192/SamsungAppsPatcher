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
  NO_PATCH=$2

  # decompile app
  apktool install-framework "originals/${app}.apk" # not sure if this line is necessary
  apktool decode -f "originals/${app}.apk" -o "decompiled/${app}"

  if [ $NO_PATCH == 0 ]; then
    cd "decompiled/$app"
      # Use dansimko's command to remove the samsung check
      cecho "GREEN" "    patching samsung check in ${app}"
      find . -type f -name "*.smali" -exec sed -i 's/sget-object \(v\|p\)\(.\+\), Landroid\/os\/Build;->\(MANUFACTURER\|BRAND\):Ljava\/lang\/String;/const-string \1\2, \"letitbeheardthisphoneistobetreatedasifitwereofabranddifferentfromtheonestartingwiths\"/g' "{}" \;

      # Use any patches we find that start with $app
      for patch in ../../patches/${app}[\_\-\.]*.patch; do
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
  else
    cecho "GREEN" "    skipped patching ${app} due to --no-patch | -n flag"
  fi
}



mkdir -p patched
mkdir -p decompiled

NO_PATCH=0
VERB_PRESENT="patching"
VERB_PAST="patched"
APKS_SPECIFIED=()
while [ ! $# -eq 0 ]; do
	case "$1" in
		--no-patch | -n)
      NO_PATCH=1
      VERB_PRESENT="decompiling"
      VERB_PAST="decompiled"
			;;
    *)
      APKS_SPECIFIED+=("$1")
	esac

	shift
done

if [ -z "$APKS_SPECIFIED" ]; then
  # if we don't specify any apps, patch all apps in the originals folder
  APKS_SPECIFIED+=(originals/*.apk)
fi

count=1
numapks=${#APKS_SPECIFIED[@]}

for ((i=0; i<$numapks; i++)); do
  app=$(basename "${APKS_SPECIFIED[$i]%.apk}")  # e.g. converts "originals/budsplugin.apk" to just "budsplugin"

  if [ ! -f "originals/${app}.apk" ]; then
    cecho "RED" "Cannot find file: originals/${app}.apk"
    echo "Please make sure that the apk is in the originals directory."
  else
    cecho "GREEN" "[${count} / ${numapks}] ${VERB_PRESENT} ${app}"
    if [[ "$(sha1sum "originals/${app}.apk")" = "47493473d3f4d1c22a2703898095ac26e0968b87"* ]]; then
      echo "    detected as dummy file, skipped"
    else
      rm -rf decompiled/${app}
      patchapk "$app" "$NO_PATCH"
    fi
    cecho "GREEN" "[${count} / ${numapks}] successfully ${VERB_PAST} ${app}"

    count=$((count+1))
  fi
  echo
done

echo
if [ $NO_PATCH == 0 ]; then
  echo 'Find all patched apps in the "patched" folder'
else
  echo 'Find all decompiled apps in the "decompiled" folder'
fi
