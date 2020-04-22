#!/usr/bin/env bash
# Build Phase Script for copying and signing a framework based on Configuration
set -o errexit
set -o nounset

STUB_FRAMEWORK_PATH_1="${BUILT_PRODUCTS_DIR}/VAStub.framework"
STUB_FRAMEWORK_PATH_2="${BUILT_PRODUCTS_DIR}/VAHTTPStub.framework"

# List all Xcode Build Configurations you want the stub framework in eg: ("Debug", "Test")
STUB_CONFIGURATIONS=("Test")

copy_library_1() {
    echo "Entering copy_library"
    rm -vRf  "${CODESIGNING_FOLDER_PATH}/PlugIns/VAStub.framework"
    mkdir -p "${CODESIGNING_FOLDER_PATH}/PlugIns/"
    cp -vRf "$STUB_FRAMEWORK_PATH_1" "${CODESIGNING_FOLDER_PATH}/PlugIns/VAStub.framework"
    echo "Exiting copy_library"
}

copy_library_2() {
    echo "Entering copy_library"
    rm -vRf  "${CODESIGNING_FOLDER_PATH}/PlugIns/VAHTTPStub.framework"
    mkdir -p "${CODESIGNING_FOLDER_PATH}/PlugIns/"
    cp -vRf "$STUB_FRAMEWORK_PATH_2" "${CODESIGNING_FOLDER_PATH}/PlugIns/VAHTTPStub.framework"
    echo "Exiting copy_library"
}

codesign_library_1() {
    echo "Entering codesign_library"
    if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" ]; then
        codesign -fs "${EXPANDED_CODE_SIGN_IDENTITY}" "${CODESIGNING_FOLDER_PATH}/PlugIns/VAStub.framework"
    fi
    echo "Exiting codesign_library"
}

codesign_library_2() {
    echo "Entering codesign_library"
    if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" ]; then
        codesign -fs "${EXPANDED_CODE_SIGN_IDENTITY}" "${CODESIGNING_FOLDER_PATH}/PlugIns/VAHTTPStub.framework"
    fi
    echo "Exiting codesign_library"
}

main() {
    echo "Copy stubs framework when using build configurations: $STUB_CONFIGURATIONS"

    local is_stub_configuration=0
    for stub_configuration in $STUB_CONFIGURATIONS; do
    echo "Inside for loop"
        if [ "${CONFIGURATION}" = "$stub_configuration" ]; then
            is_stub_configuration=1
            echo "Will copy stub framework if found"
            echo "STUB_FRAMEWORK_PATH : $STUB_FRAMEWORK_PATH_1"
            if [ -e $STUB_FRAMEWORK_PATH_1 ]; then
                echo "Inside if"
                copy_library_1 && codesign_library_1
                echo "Stub framework_1 copied"
            else
                echo "Stub framework_1 not found"
            fi

            echo "STUB_FRAMEWORK_PATH : $STUB_FRAMEWORK_PATH_2"
            if [ -e $STUB_FRAMEWORK_PATH_2 ]; then
                echo "Inside if"
                copy_library_2 && codesign_library_2
                echo "Stub framework_2 copied"
            else
                echo "Stub framework_2 not found"
            fi
            break
        fi
    done

    if [ $is_stub_configuration = 0 ]; then
        echo "Did not copy Stub framework for configuration ${CONFIGURATION}"
    fi
}

main
