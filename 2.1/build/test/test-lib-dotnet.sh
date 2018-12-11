# Functions for tests for the .NET image in OpenShift.
#
# IMAGE_NAME specifies a name of the candidate image used for testing.
# The image has to be available before this script is executed.
#
# This file is deliberately kept same across different versions of .NET image

THISDIR=$(dirname ${BASH_SOURCE[0]})

source ${THISDIR}/test-lib.sh
source ${THISDIR}/test-lib-openshift.sh

function test_dotnet_integration() {
  local image_name=$1
  local version=$2
  local import_image=${3:-}
  case ${version} in
    2*) testdir=build/test ;;
    *) testdir=test ;;
  esac
  VERSION=$version ct_os_test_s2i_app "${image_name}" \
                                      "https://github.com/redhat-developer/s2i-dotnetcore.git" \
                                      "${version}/${testdir}/asp-net-hello-world" \
                                      "Hello world" \
                                      8080 http 200 "" \
                                      "${import_image}"
}

