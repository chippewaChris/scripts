#!/bin/bash
####################################################################################################
#
# Copyright (c) 2018, JAMF Software, LLC.  All rights reserved.
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
#
#	DESCRIPTION
#     This script is intended to be used as an Extension Attribute in a Jamf Pro Server.  It's purpose
#     is to determine if a specified profile (which needs to be specified on line 46) has been succesfully
#    installed
#
####################################################################################################
#
#	HISTORY
#
#   v1.0 02/26/2018
#   Chris Cohoon
#   Jamf Support Engineer
#
####################################################################################################
# Code
# Do not modify below this line
####################################################################################################
profile=`profiles -C -v | grep attribute | awk '/name/{$1=$2=$3=""; print $0}' | grep "NAME OF PROFILE WE ARE SEAERCHING FOR"`  ## Please update this line to account for the name of the profile we are searching for.  For a list of profiles, run this command on a enrolled client "profiles -C -v | grep attribute | awk '/name/{$1=$2=$3=""; print $0}'"
if [[ ! -z "$profile" ]]; then
    echo "<result>Installed</result>"
else
    echo "<result>Failed to Install</result>"
fi

exit 0
