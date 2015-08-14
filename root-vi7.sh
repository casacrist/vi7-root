#!/system/bin/sh -x -e

# Chuwi Vi7 SuperSU install script <https://github.com/Pacien/vi7-root>
# Tailored for the stock Chuwi firmware
# Installation using the ADB root shell
#
# This script shall be executed if and only if the user is able to
# understand its purposes and possible implications.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

mount -o rw,remount /system

SU_DIR=/data/local/tmp
ARCH=x86

cp_chmod_chcon() {
	cp $1 $2
	chmod $3 $2
	chcon $4 $2
}

mkdir -p /system/app/SuperSU
cp_chmod_chcon $SU_DIR/common/Superuser.apk /system/app/SuperSU/SuperSU.apk 0644 u:object_r:system_file:s0

cp_chmod_chcon $SU_DIR/common/install-recovery.sh /system/etc/install-recovery.sh 0755 u:object_r:toolbox_exec:s0

mv /system/bin/install-recovery.sh /system/bin/install-recovery-2.sh
ln -s /system/etc/install-recovery.sh /system/bin/install-recovery.sh

mkdir -p /system/bin/.ext
cp_chmod_chcon $SU_DIR/$ARCH/su /system/xbin/su 0755 u:object_r:system_file:s0
cp_chmod_chcon $SU_DIR/$ARCH/su /system/bin/.ext/.su 0755 u:object_r:system_file:s0
cp_chmod_chcon $SU_DIR/$ARCH/su /system/xbin/daemonsu 0755 u:object_r:system_file:s0
cp_chmod_chcon $SU_DIR/$ARCH/su /system/xbin/sugote 0755 u:object_r:zygote_exec:s0

cp_chmod_chcon $SU_DIR/$ARCH/supolicy /system/xbin/supolicy 0755 u:object_r:system_file:s0
cp_chmod_chcon $SU_DIR/$ARCH/libsupol.so /system/lib/libsupol.so 0644 u:object_r:system_file:s0

cp_chmod_chcon /system/bin/sh /system/xbin/sugote-mksh 0755 u:object_r:system_file:s0

cp_chmod_chcon /system/bin/app_process32 /system/bin/app_process32_original 0755 u:object_r:zygote_exec:s0
cp_chmod_chcon /system/bin/app_process32 /system/bin/app_process_init 0755 u:object_r:system_file:s0

rm /system/bin/app_process
ln -s /system/xbin/daemonsu /system/bin/app_process

rm /system/bin/app_process32
ln -s /system/xbin/daemonsu /system/bin/app_process32

#cp_chmod_chcon $SU_DIR/common/99SuperSUDaemon /system/etc/init.d/99SuperSUDaemon 0755 u:object_r:system_file:s0  # no init.d

touch /system/etc/.installed_su_daemon

rm -R /data/local/tmp/*
#mount -o ro,remount /system  # done on reboot
/system/xbin/su --install
