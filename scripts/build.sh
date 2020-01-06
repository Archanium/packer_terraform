#!/bin/bash
set -e
set -x 
export AWS_DEFAULT_REGION=$REGION
# load our helper functions
source scripts/common.sh

# check that the tools we require are present
package_check

# 
# base.sh DIR TARGET BASE_NAME
DIR="$1"
NAME="$2"
BASE_NAME="$3"
AMI_BASE=""

if [[ -z "$DIR" ]]; then
    echo "please specify the directory as first runtime argument"
    exit 1
fi
if [[ -z "$NAME" ]]; then
    echo "please specify the name as second runtime argument"
    exit 1
fi
if [[ -z "$BASE_NAME" ]]; then
    echo "No base AMI given"
    AMI_BASE=$(curl -sSL 'https://cloud-images.ubuntu.com/query/bionic/server/released.current.txt' | grep "${REGION}" | grep hvm | grep -e 'ebs' | grep 'amd64' | awk '{print $8}' )
else
    BASE_BUILT=$(base_rebuilt $BASE_NAME)
    AMI_BASE="$(get_base_ami "$BASE_BUILT" "$NAME" "$BASE_NAME")"
fi
export AMI_BASE

SHA=$(git ls-tree HEAD "$DIR" | cut -d" " -f3 | cut -f1)
TAG_EXISTS=$(tag_exists $SHA $AMI_BASE)
export SHA

echo "latest $DIR build already exists: $TAG_EXISTS"
if [ "$TAG_EXISTS" = "false" ]; then
    packer build ${DIR}/$NAME.json
else
    touch manifest-${NAME}.json
fi
