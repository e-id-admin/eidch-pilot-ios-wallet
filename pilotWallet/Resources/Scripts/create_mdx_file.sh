echo "This creates several file within the app bunlde needed for the MAM SDK Frameworks and the MDX file needed to deploy the app on the XenMobile Server."

if [ -z $MAM_SDK_ENABLED]
then
    echo "warning: MAM_SDK_ENABLED not set. CGAppCLPrepTool is not executed"
    exit 0
else
    echo "MAM_SDK_ENABLED is set. Run CGAppCLPrepTool."
fi

set -x

export STOREURL="https://gov-ref.mobile.admin.ch"
export APPTYPE="sdkapp"
export PACKAGEID="1D54FC25-DB83-4604-840C-C1CF0F32A927" # From Info > URL Types
export APPIDPREFIX="SZ3M2Z456W" # Enterprise Team ID
export TOOLKIT_DIR="$PROJECT_DIR/Vendors/CitrixMAM/Tools"
export LOG_FILE="$PROJECT_DIR/Vendors/CitrixMAM/Tools/mdx_sdkprep.log"

if [ -z "${MDX_PATH}" ]
then
    export MDX_PATH="$CONFIGURATION_BUILD_DIR/$EXECUTABLE_NAME.mdx"
    echo "warning: set MDX_PATH to default."
fi

if [ -z "${PACKAGEID}" ]
then
    echo "PACKAGEID variable was not found or was empty, please run uuidgen at the command line and paste the output value in the PACKAGEID variable in your post build script."
    exit 1
fi

if [ -z "${APPIDPREFIX}" ]
then
    echo "APPIDPREFIX variable was not found or was empty, please refer to the \"how to\" document located in the documentation folder of the SDK package on where to find your Apple's application prefix ID."
    exit 1
fi

echo "MDX_PATH: $MDX_PATH"

"$TOOLKIT_DIR/CGAppCLPrepTool" SdkPrep -in "$CONFIGURATION_BUILD_DIR/$EXECUTABLE_FOLDER_PATH" -out "$MDX_PATH" -storeURL "${STOREURL}" -appType "${APPTYPE}" -packageId "${PACKAGEID}" -entitlements "$SRCROOT/$PROJECT/$PROJECT.entitlements" -appIdPrefix "${APPIDPREFIX}" -minPlatform "9.0" -logFile "$LOG_FILE"
