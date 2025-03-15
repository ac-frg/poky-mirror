# FIXME: the LIC_FILES_CHKSUM values have been updated by 'devtool upgrade'.
# The following is the difference between the old and the new license text.
# Please update the LICENSE value if needed, and summarize the changes in
# the commit message via 'License-Update:' tag.
# (example: 'License-Update: copyright years updated.')
#
# The changes:
#
# --- LICENSE.adoc
# +++ LICENSE.adoc
# @@ -35,7 +35,7 @@
#  
#  ----
#  Copyright (C) 2002-2007 Andrew Tridgell
# -Copyright (C) 2009-2024 Joel Rosdahl and other contributors
# +Copyright (C) 2009-2025 Joel Rosdahl and other contributors
#  ----
#  
#  
# @@ -50,7 +50,7 @@
#  
#  === src/third_party/blake3/blake3/*
#  
# -This is a subset of https://github.com/BLAKE3-team/BLAKE3[BLAKE3] 1.5.1 with the
# +This is a subset of https://github.com/BLAKE3-team/BLAKE3[BLAKE3] 1.6.1 with the
#  following license:
#  
#  ----
# @@ -390,13 +390,13 @@
#  === src/third_party/cpp-httplib/httplib.h
#  
#  cpp-httplib - A C++11 cross-platform HTTP/HTTPS library. Copied from cpp-httplib
# -v0.15.3 downloaded from https://github.com/yhirose/cpp-httplib[cpp-httplib]. The
# +v0.19.0 downloaded from https://github.com/yhirose/cpp-httplib[cpp-httplib]. The
#  library has the following license:
#  
#  ----
#  The MIT License (MIT)
#  
# -Copyright (c) 2024 yhirose
# +Copyright (c) 2025 yhirose
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
# @@ -450,12 +450,12 @@
#  
#  === src/third_party/fmt/fmt/*.h and src/third_party/fmt/fmt/format.cc
#  
# -This is a subset of https://fmt.dev[fmt] 10.2.1 with the following license:
# +This is a subset of https://fmt.dev[fmt] 11.1.4 with the following license:
#  
#  ----
#  Formatting library for C++
#  
# -Copyright (c) 2012 - present, Victor Zverovich
# +Copyright (c) 2012 - present, Victor Zverovich and {fmt} contributors
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
# --- src/third_party/cpp-httplib/httplib.h
# +++ src/third_party/cpp-httplib/httplib.h
# @@ -1,6 +1,6 @@
#  //
#  //  httplib.h
#  //
# -//  Copyright (c) 2024 Yuji Hirose. All rights reserved.
# +//  Copyright (c) 2025 Yuji Hirose. All rights reserved.
#  //  MIT License
#  //
# 
#

SUMMARY = "a fast C/C++ compiler cache"
DESCRIPTION = "ccache is a compiler cache. It speeds up recompilation \
by caching the result of previous compilations and detecting when the \
same compilation is being done again. Supported languages are C, C\+\+, \
Objective-C and Objective-C++."
HOMEPAGE = "http://ccache.samba.org"
SECTION = "devel"

LICENSE = "GPL-3.0-or-later & MIT & BSL-1.0 & ISC"
LIC_FILES_CHKSUM = "file://LICENSE.adoc;md5=b98c3470e22877fefa43a01a2dd0669c \
                    file://src/third_party/cpp-httplib/httplib.h;endline=6;md5=663aca6f84e7d67ade228aad32afc0ea \
                    file://src/third_party/nonstd-span/nonstd/span.hpp;endline=9;md5=b4af92a7f068b38c5b3410dceb30c186 \
                    file://src/third_party/win32-compat/win32/mktemp.c;endline=17;md5=d287e9c1f1cd2bb2bd164490e1cf449a \
                    "

DEPENDS = "zstd fmt xxhash"

SRC_URI = "${GITHUB_BASE_URI}/download/v${PV}/${BP}.tar.gz"

SRC_URI[sha256sum] = "7dba208540dc61cedd5c93df8c960055a35f06e29a0a3cf766962251d4a5c766"

inherit cmake github-releases

PATCHTOOL = "patch"

BBCLASSEXTEND = "native nativesdk"

PACKAGECONFIG[docs] = "-DENABLE_DOCUMENTATION=ON,-DENABLE_DOCUMENTATION=OFF,asciidoc"
PACKAGECONFIG[redis] = "-DREDIS_STORAGE_BACKEND=ON,-DREDIS_STORAGE_BACKEND=OFF,hiredis"

# ENABLE_TESTING requires doctest which is not present in oe
EXTRA_OECMAKE += "-DENABLE_TESTING=OFF"
