#!/bin/bash
####################################################################################################
#
# Copyright (c) 2017, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################
jamfPro="" ##Please configure your Jamf Pro Server URL, with port number if applicable.
username="" ##Please input a Jamf Pro user account
password="" ##Please input your credentials here
smartGroup="" ##Please configure a Smart or Static Group in the Jamf Pro Server of devices you would like to unmanage.  Provide the ID of this newly created group on this line.
################################################################################################################
#
# v1.0
# Author: Chris Cohoon, Jamf Support
#
####################################################################################################
###Test Variables:
# if [ -z "$jamfPro" ]; then
# 	echo "Please provide a Jamf Pro Server URL"
# 	exit 301
# fi
#
#
# if [ -z "$username" ]; then
# 	echo "Please provide a Jamf Pro user account"
# 	exit 302
# fi
#
#
# if [ -z "$password" ]; then
# 	echo "Please input a password"
# 	exit 303
# fi
#
#
# if [ -z "$smartGroup" ]; then
# 	echo "Please provide ID of Smart or Static group of devices, we wish to remove"
# 	exit 304
# fi
################################################################################################################
##Get device IDs from the Smart Group provided on line 5.
ids=$(curl -sku "$username:$password" "$jamfPro/JSSResource/mobiledevicegroups/id/$smartGroup" -X GET --header 'content-type: application/xml' | xmllint --xpath '/mobile_device_group/mobile_devices/mobile_device/id' - | sed 's/<id>//g' | sed 's/<\/id>/ /g')

for i in $ids
do
	#Mark the devices as unmanaged
	echo "Unmanaging device with id of $i..."
	curl -sku "$username:$password" "$jamfPro/JSSResource/mobiledevices/id/$i" -X PUT --header 'content-type: application/xml' --data '<mobile_device><general><managed>false</managed></general></mobile_device>' >> /dev/null
	if [ $? == 0 ]
	then
		echo "Successfully marked device $i as unmanaged!"
	else
		echo "Failed to mark device $i as unmanaged"
	fi
done

exit 0
