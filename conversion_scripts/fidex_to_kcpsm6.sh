#!/bin/sh
sed -f fidex_to_kcpsm6.sed  <$1 > "${1%.psm}_new.psm"
echo "Conversion done. Output ${1%.psm}_new.psm"


