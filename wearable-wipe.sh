apps=(
  "com.samsung.accessory" # accessoryservice
  "com.sec.android.app.shealth" # shealth
  "com.samsung.android.app.watchmanager" # wearable
  "com.samsung.android.app.watchmanager2" # wearable

  "com.samsung.android.geargplugin" # watchplugin
  "com.samsung.android.gearnplugin" # watch3plugin
  "com.samsung.android.waterplugin" # watch4plugin
  "com.samsung.android.gearpplugin" # activeplugin
  "com.samsung.android.gearrplugin" # active2plugin
  "com.samsung.android.modenplugin" # gearfitplugin
  "com.samsung.android.neatplugin" # gearfit2plugin
  "com.samsung.android.gearfit2plugin" # gearfit2plugin
  "com.samsung.android.gearoplugin" # gearsportplugin

  "com.samsung.accessory.fridaymgr" # budsplugin
  "com.samsung.accessory.atticmgr" # budsproplugin
  "com.samsung.accessory.berrymgr" # buds2plugin
  "com.samsung.accessory.popcornmgr" # budsplusplugin
  "com.samsung.accessory.neobeanmgr" # budsliveplugin

  "com.samsung.accessory.triathlonmgr" # Gear IconX
  "com.samsung.accessory.beansmgr" # Gear IconX (2018)
  "com.samsung.android.watch.budscontroller" # Samsung Buds Controller
)
apps_system=(
  "com.samsung.android.app.watchmanagerstub" # Wearable Manager Installer
)

echo "Uninstalling all Galaxy Wearable apps so that the modded ones can take their place without signature mismatches."
read -p "Press Enter to continue, or Ctrl+C to cancel.
"
echo "Note: If you see 'Failure [DELETE_FAILED_INTERNAL_ERROR]' it means the app was already uninstalled."
echo

adb devices

for app in "${apps[@]}"
do :
  echo "# Uninstalling $app"
  adb shell pm uninstall "$app"
done

echo

for app in "${apps_system[@]}"
do :
  echo "# Uninstalling $app"
  adb shell pm uninstall "$app"
  adb shell pm uninstall --user 0 "$app"
done
