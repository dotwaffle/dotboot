#!/bin/bash -euv
# make.sh: Creates a network boot environment using ipxe/syslinux

# Copyright 2012 Matthew Walster
# Distributed under the terms of the GNU General Public Licence

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Define a usage statement
usage()
{
	echo "$0: A network boot environment creation tool"
	echo "Usage: $0 [ OPTIONS ]"
	echo "    -o | --output [ path ]"
}

# Initialise some variables, setting sane defaults
output=./output
boot_name="dotboot network booting service"
boot_url="http://boot.vpn"

# Get the latest submodule versions specified by the git repo
git submodule init
git submodule update

# Build syslinux
cd syslinux
make
cd ..

# Build ipxe
cd ipxe/src
cp ../../syslinux/core/isolinux.bin util/ # ipxe needs isolinux.bin to build ipxe.iso
make EMBED=../../config/ipxe
cd ../..

cat menu/header >$output

for distro in $(ls distros)
do
	distros/$distro >$output
done

