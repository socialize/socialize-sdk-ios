#!/bin/sh
#
# Copyright 2013 ShareThis
# Add-on to XcodeCoverage
#

remove_old_report()
{
    if [ -e ${COMBINED_COVERAGE_OUTPUT_DIR} ]; then
        rm -r ${COMBINED_COVERAGE_OUTPUT_DIR}
    fi
}

enter_lcov_dir()
{
    mkdir -p ${COMBINED_COVERAGE_OUTPUT_DIR}
    cd ${COMBINED_COVERAGE_OUTPUT_DIR}
}

generate_report()
{
	echo "${COMBINED_COVERAGE_OUTPUT_DIR}"
    "${LCOV_PATH}/genhtml" --title "Combined" --output-directory ${COMBINED_COVERAGE_OUTPUT_DIR} ../UnitTests-Coverage.info ../IntegrationTests-Coverage.info ../UIIntegrationTests-Coverage.info --legend
}

LCOV_PATH=${PWD}/Scripts/lcov-1.10/bin
COMBINED_COVERAGE_OUTPUT_DIR=${PWD}/build/test-coverage/combined
remove_old_report
enter_lcov_dir
generate_report