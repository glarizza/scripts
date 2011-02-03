#!/bin/bash
# mac_warranty.sh
# Description: Looks up Apple warranty info for this computer and adds to LANDesk custom data
#
# Patrick Gallagher
# http://macadmincorner.com
# Modified 01/11/2009


defaultsCommand="/usr/bin/defaults"
plistFile="/Library/Application Support/LANDesk/data/ldscan.core.data"
tmpFile="/tmp/warranty.txt"
serialNum=`system_profiler SPHardwareDataType | grep "Serial Number" | awk -F ': ' {'print $2'} 2>/dev/null`
app="AppleCare Protection Plan"


[[ -n "${serialNum}" ]] && WarrantyInfo=`curl -k -s "https://selfsolve.apple.com/Warranty.do?serialNumber=${serialNum}&country=USA&fullCountryName=United%20States" | awk '{gsub(/\",\"/,"\n");print}' | awk '{gsub(/\":\"/,":");print}' > ${tmpFile}`



# Functions

getWarranty()
{
	grep ^"${1}" ${tmpFile} | awk -F ':' {'print $2'}
}

getPHCovDesc()
{
	grep ^"${1}" ${tmpFile} | awk -F ':' {'print $2'}
}

getCovDesc()
{
	grep ^"${1}" ${tmpFile} | awk -F ':' {'print $2'}
}

InvalidSerial=`grep "serial number provided is invalid" "${tmpFile}"`

if [[ -e "${tmpFile}" && -z "${InvalidSerial}" ]] ; then
	# Is there phone coverage available?
	phCoverageDescription=`getPHCovDesc PHCOVERAGE_DESC`
	if [ "$phCoverageDescription" == "${app}" ]; then
		${defaultsCommand} write "$plistFile" "Custom Data - Mac - Warranty - Phone Coverage" "Available - Call 800-800-2775"
	else
		${defaultsCommand} write "$plistFile" "Custom Data - Mac - Warranty - Phone Coverage" "${phCoverageDescription}"
	fi
	
	# Type of coverage
	coverageDescription=`getCovDesc COVERAGE_DESC`
	${defaultsCommand} write "$plistFile" "Custom Data - Mac - Warranty - Coverage Description" "${coverageDescription}"
	
	# Warranty Expires...
	WarrantyExpires=`getWarranty COVERAGE_DATE`
	if [ "${WarrantyExpires}" == "" ]; then 
		${defaultsCommand} write "$plistFile" "Custom Data - Mac - Warranty - Warranty Expires" "Expired"
	else
	${defaultsCommand} write "$plistFile" "Custom Data - Mac - Warranty - Warranty Expires" "${WarrantyExpires}"
	fi
	
	# Serial Number
	${defaultsCommand} write "$plistFile" "Custom Data - Mac - Warranty - Serial Number" "${serialNum}"
	
	# Purchase Date....
	purchaseDate=`getWarranty PURCHASE_DATE`
	${defaultsCommand} write "$plistFile" "Custom Data - Mac - Warranty - Purchase Date" "${purchaseDate}"
	
	
else
	[[ -z "${serialNum}" ]] && ${defaultsCommand} write $plistFile "Custom Data - Mac - Serial Number" "Error getting serial, Logic board replaced?"
	[[ -n "${InvalidSerial}" ]] && ${defaultsCommand} write $plistFile "Custom Data - Mac - Warranty Expires" "Not Found"
fi
	
# echos to the console
defaults read "${plistFile}"
exit 0
