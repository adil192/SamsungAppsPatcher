# Samsung Apps Patcher for Samsung phones with custom ROMs

This is a guide to patch galaxy wearable apps to work on a modified samsung phone. This was originally taken from an [xda post by dansimko](https://forum.xda-developers.com/t/app-mod-galaxy-wearable-patch-for-samsung-phones-with-custom-roms.4208143/) but I wanted to make it a little easier to follow. I've since scripted the process, kept the patches up to date, and added new patches. The scripts are written for linux in bash, so if you're using something else, you could try the old (manual) guide at https://gist.github.com/adil192/ab95808fb66b6cde3d63ded6c19b0f1d.



## Download pre-patched apps

I've added some prepatched apks and the platform-tools zip file to this MEGA drive: https://mega.nz/folder/sUFj2C5b#M4zEP-c9ylY-ENxPw7qCUQ.



## App support

These are the apps that probably work along with a link to apkmirror where you can download an **unpatched** apk. Please note that I cannot test the majority of the plugins because I don't have the devices myself.

### Core

1. accessoryservice.apk | [Samsung Accessory Service](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/samsung-accessory-service/) | ★★★★★ Verified working by me
2. shealth.apk | [Samsung Health](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/s-health/) | ★★★★★ Verified working by me
3. wearable.apk | [Galaxy Wearable](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/samsung-gear/) | ★★★★★ Verified working by me

### Watch plugins

1. watchplugin.apk | [Galaxy Watch Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-watch-plugin/) | ★★★★★ Verified working by me
2. watch3plugin.apk | [Galaxy Watch3 Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-watch3-plugin/) | ★★☆☆☆ Untested
3. watch4plugin.apk | [Galaxy Watch4 Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-watch4-plugin/) | ☆☆☆☆☆ Not working
4. activeplugin.apk | [Watch Active Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/watch-active-plugin/) | ★★☆☆☆ Untested
5. active2plugin.apk | [Watch Active2 Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/watch-active2-plugin/) | ☆☆☆☆☆ Not working
4. gearfit2plugin.apk | [Gear Fit2 Plugin](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/gear-fit2-plugin/) | ★★★★☆ Probably working
5. gearsportplugin.apk | [Gear S Plugin ](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/gear-s-plugin/) | ★★★★☆ Probably working
6. Other watches: Watch plugins that integrate with Samsung Health verify their certificate so they won't work without a specific custom certificate patch (there's a section below on how to patch it yourself). (☆☆☆☆☆)

### Other plugins

1. budsplugin.apk | [Galaxy Buds Manager](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds-plugin/) | ★★★★★ Verified working by me
2. budsproplugin.apk | [Galaxy Buds Pro Manager](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds-pro/) | ★★★★☆ Probably working
3. buds2plugin.apk | [Galaxy Buds2 Manager](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds2/) | ★★★★☆ Probably working
4. budsplusplugin.apk | [Galaxy Buds+ Manager](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds-plugin-2/) | ★★★★☆ Probably working
5. budsliveplugin.apk | [Galaxy Buds Live Manager](https://www.apkmirror.com/apk/samsung-electronics-co-ltd/galaxy-buds-live-plugin/) | ★★★★☆ Probably working
5. Other plugins: These will most likely work without any customised patches needed. Just run the apk through `./wearable-patcher.sh`. (★★★☆☆)



## How to use the scripts

0. Make sure your system satisfies the requirements (below) first.
1. Download the unpatched apks of the three core apps and any plugins you need. You can find the links in the [App support](https://github.com/adil192/SamsungAppsPatcher#app-support) section. Save these into the `SamsungAppsPatcher/originals` folder. Feel free to delete the dummy apks first as they're just there to make sure you name your downloaded apks correctly.
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



## Generating a certificate (not necessary)

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

4. Get the hex for your certificate: Open a terminal in the `SamsungAppsPatcher` folder and enter `keytool -alias key0 -exportcert -keystore keystore.jks -storepass password1 | xxd -p`, replacing `password1` with yours. Now remove the spaces/linebreaks from the output of this command, and keep it on hand. You'll need to open each patch file, and where the existing signature is added, replace it with yours. Make sure you only replace the signature on lines beginning with a `+`.

   ![image](https://user-images.githubusercontent.com/21128619/142562030-6ef6528a-f474-42a2-b3f2-142ea0bff430.png)


## How to patch an new watch plugin

1. Download the apk of the app you want to patch into the `originals` folder (rename it to something simple like active2plugin.apk to make things easier).

2. Run the wearable-patcher.sh script with the apk you downloaded earlier, but with the `--no-patch` flag: `./wearable-patcher.sh active2plugin.apk --no-patch`. You should now have the decompiled app in the decompiled folder. Move the terminal to this folder: e.g. `cd decompiled/active2plugin/`

3. Make a local git repo. This will make it easy to generate a patch file later.

  ```bash
  git init
  git add *
  git commit -m "Initial commit"
  ```

4. Open the app folder in something like Atom or Sublime Text: `atom .`. You can look at other patches in the patches folder; for example, the watchplugin (original Galaxy Watch) needed to patch the file `smali_classes2/com/samsung/accessory/goproviders/shealthproviders/util/Signaturechecker.smali`. Essentially you just want to add the signature of the provided keystore (below) to the valid list of signatures. You might want to start with searching the decompiled app for `Landroid/content/pm/Signature` to find potentially relevant areas of code.

  ```
  308202ef308201d7a003020102020414698683300d06092a864886f70d01010b05003028312630240603550403131d53616d73756e6750617463682050617463684365727469666963617465301e170d3231303830323139303032345a170d3436303732373139303032345a3028312630240603550403131d53616d73756e675061746368205061746368436572746966696361746530820122300d06092a864886f70d01010105000382010f003082010a0282010100e7305c88fe815cad51ee59c6d424833dcef3ebcca98a64d43f5e7fce0225dc7131625fb0d07858b64c7a8da6a7c38a6361f3d8a8ef057e2d533c2e35132c5ca1452ef0b3e7b987ff34afc483626f1a8c89f76be9fd4e85c676040906b8601c3bdf01e373c156fbeb94159b0e7cc66c68d6a1900811f0d8d80328bb5807876d7d5f0f9768c0f98e66ebab0aa0f8966f11092d35130f375c06f7ca0d1d5abc2ed4c9eea664349f06e80ed09e4ac214bb61f085848b1733846b1eb771f1b41163e0babc4510392cb15f4f454a4b91bf1a07267e34d7daaa9da811d4c082fccd4ddc028cda3733a85991f7c9c218b14d03cedaa73599a8d8d033a4bfab44dc377cef0203010001a321301f301d0603551d0e0416041439f1b24007584379561b2d19af849f71da60d2dc300d06092a864886f70d01010b050003820101008315f6c17aa4eb4620da01163133265d1b4e8cf0788acaa19cb54c7f8e0fcd683e4aa9da7132db2804fa9feef2d0809a258058aaf75386c53577a12fa9656a6d5a6812aace735196452e51c6a4cdc4a83b5227361e7b1710f1023235206637371974cb95d009777559d05c8af510f80d4d527904039810fd8f887e3a39039bfe62f97d63d9f20df09c2df8d2b2a6e18d4790d38edb61d0685f534333189d938e36c07d6cfe5c67e2df92dabd5c33e57a40885ac8f79ba93223d4917f850b5bdf4cc79a6a73dcca34982efe71a25b5ae12c7dc142b6c62d637b8b061155eb40381be335a7bc159443993ca73fd80e79a4177fc62455fedef6e4c6e405a7f5fb61
  ```

5. When you're done, convert the changes you made to a .patch file.

  ```bash
  git add *
  git commit -m "custom cert"
  git format-patch -1
  ```

6. You'll then get a patch file named like `0001-custom-cert.patch`. Rename this so that it begins with the apk name: e.g. `active2plugin-custom-cert.patch`, and move it to the `patches` folder.

  ```bash
  mv 0001-custom-cert.patch ../../patches/active2plugin-custom-cert.patch
  cd ../../  # move back to the PatchedApps folder
  ```

7. Re-run the wearable-patcher.sh script, without the --no-patch flag. Then you can install the patched app from the patched folder.

  ```bash
  ./wearable-patcher.sh active2plugin.apk
  ```

8. If your patch works, feel free to contribute to the project. Go to the [issues tab](https://github.com/adil192/SamsungAppsPatcher/issues) and make a new issue with your .patch file attached. (or do a pull request)
