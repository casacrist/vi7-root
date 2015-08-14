Vi7 root install script
=======================

This repository contains a tailored version of the SuperSU install script.
It is intended to work exclusively on the Chuwi Vi7 tablet running the almost stock Android 5.1 firmware.

This script, which is meant to be run in an ADB root shell, simply copies the root binaries to the `/system` partition and applies the right permissions to those.


Disclaimer
----------

This procedure shall be followed if and only if the reader is fully able to understand its purposes and possible implications.

As always, THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Prerequisites
-------------

- [ADB platform-tools](https://developer.android.com/tools/sdk/tools-notes.html)
- [SuperSU Update zip archive (v2.46)](https://download.chainfire.eu/696/SuperSU)



Rooting procedure
-----------------

### Disabling `verity`

Disabling verity is required to be able to boot an altered `/system` partition.

```bash
adb root
adb disable-verity
adb reboot
```

### Copying required files

The content of the SuperSU Update archive has to be unzipped into a folder on the reader's computer.
Both this folder (named `UPDATE-SuperSU-v2.46` here) and the custom install script have then to be sent to the device.

```bash
adb root
adb push UPDATE-SuperSU-v2.46 /data/local/tmp/
adb push root-vi7.sh /data/local/tmp/
```

### Running the install script

Running the custom installation script will:

- try to remount the `/system` partition in read and write mode,
- copy the necessary binaries,
- applies the right permissions to those,
- complete the `su` binary installation,
- remove the temporary files sent to the device in `/data/local/tmp/`.


```bash
adb shell /system/bin/sh -x -e /data/local/tmp/root-vi7.sh
```

### Installing a root checking app

Optionnally, the reader may want to install a root checking app like [Root Checker](https://www.apkmirror.com/apk/joeykrim/root-checker-basic/root-checker-basic-5-5-3-android-apk-download/)

```bash
adb install com.joeykrim.rootcheck-5.5.3-94-minAPI11.apk
```

### Reboot

A reboot of the device is required to complete the procedure.

```bash
adb reboot
```


Following updates
-----------------

Vendor's OTA updates or SuperSU APK and binary updates may break the aquired root. It is advised to avoid any of these updates.


Disaster recovery
-----------------

It is reminded to the reader that flashing the factory image should still be possible in the case of a bootloop. This kind of image may be obtained on dedicated forums.


Enhancements
------------

Pull requests aimed to correct or enhance this procedure are welcome.
