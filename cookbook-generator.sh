#!/bin/bash
#Variables
COOKBOOK="$1"
MAINTAINER='Sebastien Chartrand'
MAINTAINER_EMAIL='sebastien.chartrand@fujitsu.com'
ORG='aink99'
#Set sed gsed for mac needs brew
SED=gsed

#Print usage
        usage () {
        echo "Usage:  cookbook-generator.sh [coobook name]"
}

#Check if have a least 1 parameter
if [[ $# -lt 1 ]]
then
usage
exit 1
fi



chef generate cookbook ${COOKBOOK}
cd ${COOKBOOK}
chef generate recipe default
chef generate attribute  default
cd ..


# Set maintainer

${SED} -i "s|The Authors|${MAINTAINER}|g" ${COOKBOOK}/metadata.rb
${SED} -i "s|you@example.com|${MAINTAINER_EMAIL}|g" ${COOKBOOK}/metadata.rb
${SED} -i "s|<insert_org_here>|${ORG}|g" ${COOKBOOK}/metadata.rb



