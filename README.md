# Samsung Apps Patcher for Samsung phones with custom ROMs

This is a guide to patch galaxy wearable apps to work on a modified samsung phone. This was originally taken from an [xda post by dansimko](https://forum.xda-developers.com/t/app-mod-galaxy-wearable-patch-for-samsung-phones-with-custom-roms.4208143/) but I wanted to make it a little easier to follow. I've since scripted the process, kept the patches up to date, and added new patches. The scripts are written for linux in bash, so if you're using something else, you could try the old (manual) guide at https://gist.github.com/adil192/ab95808fb66b6cde3d63ded6c19b0f1d.



## Download pre-patched apps

I've added some prepatched apks and the platform-tools zip file to this MEGA drive: https://mega.nz/folder/sUFj2C5b#M4zEP-c9ylY-ENxPw7qCUQ.



## How to use the scripts

0. Make sure your system satisfies the requirements (below) first.

1. Download the unmodified apks of the following if you need them (I got them from apkmirror, linked below). Save these into the `SamsungAppsPatcher/originals` folder, overwriting an existing dummy file if one exists (this is to make sure the names match up with the patch files). If a dummy file doesn't exist, just name the apk something short and descriptive. Then delete any dummy files that you haven't replaced.

   1. accessoryservice.apk: [Samsung Accessory Service](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/samsung-accessory-service/) *[REQUIRED]*
   2. shealth.apk: [Samsung Health](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/s-health/) *[REQUIRED]*
   3. wearable.apk: [Galaxy Wearable](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/samsung-gear/) *[REQUIRED]*
   4. watchplugin.apk: [Galaxy Watch Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-watch-plugin/)
   5. gearfit2plugin.apk: [Gear Fit2 Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/gear-fit2-plugin/)
   6. gearsportplugin.apk: [Gear S Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/gear-s-plugin/)
   7. budsplugin.apk: [Galaxy Buds Plugin/Manager](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds-plugin/)
   8. budsproplugin.apk: [Galaxy Buds Pro Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds-pro/)
   9. buds2plugin.apk: [Galaxy Buds2 Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds2/) *[not tested]*
   10. budsplusplugin.apk: [Galaxy Buds+ Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds-plugin-2/) *[not tested]*
   11. budsliveplugin.apk: [Galaxy Buds Live Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds-live-plugin/) *[not tested]*
   12. Other plugins: These will probably work fine unless they're a watch and need to integrate with samsung health, which means they need a specific signature verification patch.

2. Open a terminal in the `SamsungAppsPatcher` folder. Run `./wearable-patcher.sh` to automatically patch all the apps from the `SamsungAppsPatcher/originals` folder.
   - Sidenote: you can also patch a specific app like this: `./wearable-patcher.sh shealth`.

3. Install the patched apks! You can do this with the `./wearable-installer.sh` script to batch install them, or just install them regularly.



## Requirements

1. Install apktool. You can find the official instructions [here](https://ibotpeaches.github.io/Apktool/install/). If you're on Pop OS like me, the apktool you install through apt is out of date (you'll want at least 2.6.0) so make sure to follow those instructions.

2. If you don't want to use my keystore, install Android Studio. You could also generate a keystore without Android Studio and I've linked a guide for that. I recommend that you use the provided keystore so you can update between your patched apps and mine without losing data.

3. Install the latest version of platform-tools.

   1. You can install platform-tools and build-tools through Android Studio. For me they are located at `~/Android/Sdk/platform-tools/` and `~/Android/Sdk/build-tools/31.0.0/` respectively. You should add these to your PATH, e.g. add the following to your `~/.bashrc`...

      ```bash
      # add android platform-tools and build-tools to path
      export PATH="~/Android/Sdk/platform-tools/:$PATH"
      export PATH="~/Android/Sdk/build-tools/31.0.0/:$PATH"
      ```

   2. If that doesn't work out for you, I have zipped up a combined platform-tools and build-tools folder in the MEGA drive. Extract this to a folder like `~/platform-tools` and add it to path, e.g. add the following to your `~/.bashrc`...

      ```bash
      # add android platform tools to path
      export PATH="~/platform-tools:$PATH"
      ```

   3. Run the command `source ~/.bashrc` to update your path in your current terminal.

4. Clone/Download this repo somewhere.

   ```bash
   git clone "https://github.com/adil192/SamsungAppsPatcher"
   ```



## Generating a certificate (optional)

0. If you're not using Android Studio, follow [this](https://stackoverflow.com/questions/3997748/how-can-i-create-a-keystore) to generate a keystore. Otherwise do the following...

1. Open Android Studio and select `Build` > `Generate Signed Bundle / APK...` from the toolbar (you may need to create an empty project first).

2. Select APK/whatever, then choose to `Create new` for the key store.

   1. Choose a key store path for your new keystore. I'll be storing it as `SamsungAppsPatcher/keystore.jks`.
   2. Choose a password for the keystore (e.g. `password1`), and a password for the key (e.g. `password2`). These passwords can be the same if you want.
   3. Fill in the rest of the form and click OK.

3. Create a password file: create a file at `SamsungAppsPatcher/ks-pass.txt` and on the first line, enter your keystore password, and on the second line, enter your key password.

   ```
   password1
   password2
   ```

4. Get the hex for your certificate: Open a terminal in the `SamsungAppsPatcher` folder and enter `keytool -alias key0 -exportcert -keystore keystore.jks -storepass password1 | xxd -p`, replacing `password1` with yours. Now open both the .patch files and replace the existing hex with the output of this command (make sure to remove any spaces/linebreaks).

   ![image](https://user-images.githubusercontent.com/21128619/142562030-6ef6528a-f474-42a2-b3f2-142ea0bff430.png)

