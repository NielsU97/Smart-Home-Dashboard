# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appSmartDashboard_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appSmartDashboard_autogen.dir\\ParseCache.txt"
  "appSmartDashboard_autogen"
  )
endif()
