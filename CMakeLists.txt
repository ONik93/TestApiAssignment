cmake_minimum_required(VERSION 3.14)

project(TestApiAssignment VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick)
find_package(OpenSSL REQUIRED)

set(HEADER_FILES
    header/NetworkManager.h
    header/NetworkDefines.h
    header/UsersModel.h
    header/PositionsModel.h
    header/DataStructures.h
    header/FileHelper.h
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

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(TestApiAssignment
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET TestApiAssignment APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
	add_library(TestApiAssignment SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
	add_executable(TestApiAssignment
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(TestApiAssignment
  PRIVATE
  Qt${QT_VERSION_MAJOR}::Core
  Qt${QT_VERSION_MAJOR}::Quick
  OpenSSL::SSL
  OpenSSL::Crypto
)

target_include_directories(TestApiAssignment PRIVATE header)

set_target_properties(TestApiAssignment PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS TestApiAssignment
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if (WIN32)
    set(QT_BIN_DIR "C:/Qt/5.15.2/msvc2019_64/bin")
    set(OPENSSL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/third-party/OpenSSL")

    add_custom_command(TARGET TestApiAssignment POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "${OPENSSL_DIR}/libcrypto-1_1-x64.dll" "$<TARGET_FILE_DIR:TestApiAssignment>"
    )
    add_custom_command(TARGET TestApiAssignment POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "${OPENSSL_DIR}/libssl-1_1-x64.dll" "$<TARGET_FILE_DIR:TestApiAssignment>"
    )
    add_custom_command(TARGET TestApiAssignment POST_BUILD
        COMMAND ${QT_BIN_DIR}/windeployqt --verbose 2 --qmldir ${CMAKE_SOURCE_DIR} $<TARGET_FILE:TestApiAssignment>
    )
endif()

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(TestApiAssignment)
    qt_finalize_executable(TestApiAssignment)
endif()
