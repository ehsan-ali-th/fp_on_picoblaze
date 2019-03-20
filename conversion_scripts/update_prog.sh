#!/bin/sh

./hex2ch pBlaze_prog.hex
cp -v -f pBlaze_prog.h /home/esi/workspace/Vivado_2018.2/zcu104/fft2/fft2.sdk/fft2/src
