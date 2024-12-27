cmake_minimum_required(VERSION 3.30)
project(AdventOfCode)

set(CMAKE_CXX_STANDARD 23)

add_executable(AdventOfCode main.cpp
        day8.h
        day8.cpp)

find_package(OpenMP)
if (OpenMP_CXX_FOUND)
    target_link_libraries(AdventOfCode PUBLIC OpenMP::OpenMP_CXX)
endif ()

set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
find_package(Boost 1.86 REQUIRED headers)
target_link_libraries(AdventOfCode PUBLIC Boost::headers)
