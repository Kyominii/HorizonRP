#!/bin/bash
rm /home/cache/http-files/*

fx_root=`dirname "$(readlink -f "$0")"`

MONO_PATH=$fx_root/mono/ mono $fx_root/CitizenMP.Server.exe $*
