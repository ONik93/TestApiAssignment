cmake_minimum_required(VERSION 3.14)

project(TestApiAssignment VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick)
if (WIN32)
    find_package(OpenSSL REQUIRED)
    find_package(Vulkan REQUIRED)
endif()

set(HEADER_FILES
    header/NetworkManager.h
    header/NetworkDefines.h
    header/UsersModel.h
    header/PositionsModel.h
    header/DataStructures.h
    header/FileHelper.h
    header/Version.h.in
)
set(SOURCE_FILES
    src/main.cpp
    src/NetworkManager.cpp
    src/UsersModel.cpp
    src/PositionsModel.cpp
    src/FileHelper.cpp
)
set(RESOURCE_FILES
    UI.qrc
    Assets.qrc
)
set(PROJECT_SOURCES
    ${HEADER_FILES}
    ${SOURCE_FILES}
    ${RESOURCE_FILES}
)

# Add a custom target to generate version header
# ToDo: Now it works only if re-generate cmake. Try to make it hapend each build time.
set(PROJECT_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
string(TIMESTAMP BUILD_DATE "%Y-%m-%d %H:%M:%S")
include(cmake/generate_version_header.cmake)
add_custom_target(update_version_header ALL
    COMMAND ${CMAKE_COMMAND} -DPROJECT_ROOT_DIR=${PROJECT_ROOT_DIR} -DPROJECT_VERSION_MAJOR=${PROJECT_VERSION_MAJOR} -DPROJECT_VERSION_MINOR=${PROJECT_VERSION_MINOR} -DPROJECT_VERSION_PATCH=${PROJECT_VERSION_PATCH} -DBUILD_DATE="${BUILD_DATE}" -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/generate_version_header.cmake
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)

    # set(RESOURCES src/main.cpp)
    # qt6_add_resources(RESOURCES
    #     UI.qrc
    #     Assets.qrc
    # )

    qt_add_executable(${PROJECT_NAME}
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )

    qt_add_qml_module(${PROJECT_NAME}
        URI TestApi
        VERSION 1.0
        QML_FILES
            main.qml
            OpenFileDialog.qml
            TabAddUser.qml
            TabUsers.qml
            Styles/Default.qml
    )

    if(ANDROID)
        # Define the path to OpenSSL for Android arm64-v8a.
        if(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64" OR CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
            message("ARM64 architecture detected")
            set(ANDROID_OPENSSL_3_PATH "$ENV{LOCALAPPDATA}/Android/Sdk/android_openssl/ssl_3/arm64-v8a")
        elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "armv7l")
            message("ARMv7 architecture detected")
            set(ANDROID_OPENSSL_3_PATH "$ENV{LOCALAPPDATA}/Android/Sdk/android_openssl/ssl_3/armeabi-v7a")
        elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
            message("x86_64 architecture detected")
            set(ANDROID_OPENSSL_3_PATH "$ENV{LOCALAPPDATA}/Android/Sdk/android_openssl/ssl_3/x86_64")
        elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86")
            message("x86 architecture detected")
            set(ANDROID_OPENSSL_3_PATH "$ENV{LOCALAPPDATA}/Android/Sdk/android_openssl/ssl_3/x86")
        else()
            message("Unknown architecture: ${CMAKE_SYSTEM_PROCESSOR}")
        endif()

        set_target_properties(${PROJECT_NAME} PROPERTIES
            QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
            QT_ANDROID_EXTRA_LIBS ${ANDROID_OPENSSL_3_PATH}/libssl_3.so
            QT_ANDROID_EXTRA_LIBS ${ANDROID_OPENSSL_3_PATH}/libcrypto_3.so
        )
    elseif (IOS)
        #ToDo: Check it.
        set_target_properties(${PROJECT_NAME} PROPERTIES
            MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
            MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
            MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
            MACOSX_BUNDLE TRUE
            WIN32_EXECUTABLE TRUE
        )
    endif()
else()
    #ToDo: Write code for Qt5
endif()

if (WIN32)
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Quick
        OpenSSL::SSL
        OpenSSL::Crypto
    )
else()
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Quick
    )
endif()

target_include_directories(${PROJECT_NAME} PRIVATE header)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if (WIN32)
    # Find the path to the windeployqt executable
    find_program(WINDEPLOYQT_EXECUTABLE NAMES windeployqt)
    if(NOT WINDEPLOYQT_EXECUTABLE)
        message(FATAL_ERROR "windeployqt not found.")
    endif()

    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "$ENV{OPENSSL_ROOT_DIR}/bin/libcrypto-3-x64.dll" "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
    )
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "$ENV{OPENSSL_ROOT_DIR}/bin/libssl-3-x64.dll" "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
    )
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${WINDEPLOYQT_EXECUTABLE} --verbose 2 --qmldir ${CMAKE_SOURCE_DIR} $<TARGET_FILE:${PROJECT_NAME}>
    )
endif()

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(${PROJECT_NAME})
    qt_finalize_executable(${PROJECT_NAME})
endif()
