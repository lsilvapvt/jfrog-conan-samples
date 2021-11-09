cmake_minimum_required(VERSION 3.15)
project(hellopkg CXX)

add_library(hellopkg src/hellopkg.cpp)

set_target_properties(hellopkg PROPERTIES PUBLIC_HEADER "src/hellopkg.h")
install(TARGETS hellopkg DESTINATION "."
        PUBLIC_HEADER DESTINATION include
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        )
