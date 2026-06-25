# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/src/libvterm")
  file(MAKE_DIRECTORY "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/src/libvterm")
endif()
file(MAKE_DIRECTORY
  "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/src/libvterm-build"
  "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix"
  "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/tmp"
  "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/src/libvterm-stamp"
  "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/src"
  "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/src/libvterm-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/src/libvterm-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/Users/simondanielsson/.emacs.d/elpa/vterm-20260528.1919/build/libvterm-prefix/src/libvterm-stamp${cfgdir}") # cfgdir has leading slash
endif()
