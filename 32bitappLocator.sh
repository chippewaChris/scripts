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
#
#       DESCRIPTION
#
#   Reads Adam IDs out of a JSS Sumamry, and then queries Apple's iTunes API to verify wether or not
#   the apps are 32-bit only.
#
####################################################################################################
#
#       HISTORY
#
# V1.0 Chris Cohoon
#    10/10/17
#
# V1.1 Chris Cohoon
#    10/20/17
#    - Altered to request JSS Summary, as opposed to a list of Adam IDs
#
# V1.2 Corey Sather
#    11/14/17
#    - Added IF statement to only display apps which are 32-bit only.
#
# V1.3 Matt Aebly
#    11/15/2017
#    - Added the name of the app to the output
####################################################################################################
# Code
# Do not modify below this line
####################################################################################################
echo "Feed me a JSS Summary please..."
read file
echo "The follow application IDs are 32bit only:"
for i in $(cat $file | grep "iTunes ID                                  " | awk '{print$3}'); do
  if [[ $(curl -s "https://uclient-api.itunes.apple.com/WebObjects/MZStorePlatform.woa/wa/lookup?p=mdm-lockup&caller=MDM&platform=itunes&cc=us&l=en&id=$i" | python -mjson.tool | grep is32bitOnly | cut -d: -f2 | sed 's/,$//')  = " true" ]]; then
      echo "Adam ID $i"
      echo "  App name is $(curl -s "https://uclient-api.itunes.apple.com/WebObjects/MZStorePlatform.woa/wa/lookup?p=mdm-lockup&caller=MDM&platform=itunes&cc=us&l=en&id=$i" | python -mjson.tool | grep nameRaw | cut -d: -f2 | sed 's/,$//')"
  fi
done
