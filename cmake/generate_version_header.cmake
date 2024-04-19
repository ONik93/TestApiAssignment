# Delete existing version header file, if it exists
if(EXISTS ${PROJECT_ROOT_DIR}/header/Version.h)
    file(REMOVE ${PROJECT_ROOT_DIR}/header/Version.h)
endif()

set(INPUT_TEMPLATE ${PROJECT_ROOT_DIR}/header/Version.h.in)
set(OUTPUT_HEADER ${PROJECT_ROOT_DIR}/header/Version.h)

# Configure version header using the template
configure_file(${INPUT_TEMPLATE} ${OUTPUT_HEADER} @ONLY)
