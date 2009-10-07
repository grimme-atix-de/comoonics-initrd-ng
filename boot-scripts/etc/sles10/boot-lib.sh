#
# $Id: boot-lib.sh,v 1.5 2009-10-07 12:06:13 marc Exp $
#
# @(#)$File$
#
# Copyright (c) 2007 ATIX AG.
# Einsteinstrasse 10, 85716 Unterschleissheim, Germany
# All rights reserved.
#
# This software is the confidential and proprietary information of ATIX
# GmbH. ("Confidential Information").  You shall not
# disclose such Confidential Information and shall use it only in
# accordance with the terms of the license agreement you entered into
# with ATIX.
#
#****h* comoonics-bootimage/boot-lib.sh
#  NAME
#    boot-lib.sh
#    $id$
#  DESCRIPTION
#*******

#****f* boot-lib.sh/create_chroot
#  NAME
#    create_chroot build a chroot environment
#  SYNOPSIS
#    function create_chroot($chroot_source $chroot_path) {
#  MODIFICATION HISTORY
#  USAGE
#  create_chroot
#  IDEAS
#
#  SOURCE
#
function create_chroot () {
  chroot_source=$1
  chroot_path=$2

  exec_local cp -axf $chroot_source $chroot_path
  exec_local rm -rf $chroot_path/var/run/*
  exec_local mkdir -p $chroot_path/tmp
  exec_local chmod 755 $chroot_path
  is_mounted $chroot_path/dev || exec_local mount -t tmpfs none $chroot_path/dev
#  exec_local mount --bind /dev $chroot_path/dev
  exec_local cp -a /dev $chroot_path/
  is_mounted $chroot_path/dev/pts || exec_local mount -t devpts none $chroot_path/dev/pts
  is_mounted $chroot_path/proc || exec_local mount -t proc proc $chroot_path/proc
  is_mounted $chroot_path/sys || exec_local mount -t sysfs sysfs $chroot_path/sys
}
#************ create_chroot

#****f* boot-lib.sh/sles10_detectHalt
#  NAME
#    sles10_detectHalt build a chroot environment
#  SYNOPSIS
#    function sles10_detectHalt($xkillall_procsfile, $rootfss) {
#  MODIFICATION HISTORY
#  USAGE
#  sles10_detectHalt
#  IDEAS
#
#  SOURCE
#
sles10_detectHalt() {
    local runlevel2=$1
    local command="halt -p"
    local newroot=$2
    local oldroot=$3
    [ -z "$runlevel2" ] && runlevel2=0
    if [ $runlevel2 -eq 0 ]; then # case halt
      case `/bin/uname -m` in
        i?86)
          command="halt"
          if test -e /proc/apm -o -e /proc/acpi -o -e /proc/sys/acpi ; then
            command="halt -p"
          else
            read cmdline < /proc/cmdline
            case "$cmdline" in
              *apm=smp-power-off*|*apm=power-off*)  command="halt -p" ;;
            esac
          fi
          ;;
         *)  
          command="halt -p"
          ;;
      esac
    elif [ $runlevel2 -eq 6 ]; then
      command="reboot"
    fi
    echo $command
}
#************** sles10_detectHalt


