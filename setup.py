#!/usr/bin/env python3
#
# Copyright (C) 2020  Sutou Kouhei <kou@clear-code.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program.  If not, see
# <http://www.gnu.org/licenses/>.

import re
import subprocess

import setuptools

import Cython.Build

def pkg_config(*args):
    process = subprocess.run(['pkg-config', *args],
                             stdout=subprocess.PIPE,
                             check=True,
                             encoding='utf-8')
    return process.stdout

only_I = pkg_config('--cflags-only-I', 'groonga')
include_dirs = re.split(r'\s*-I', only_I.strip())[1::]
only_L = pkg_config('--libs-only-L', 'groonga')
library_dirs = re.split(r'\s*-L', only_L.strip())[1::]
only_l = pkg_config('--libs-only-l', 'groonga')
libraries = re.split(r'\s*-l', only_l.strip())[1::]
extension = [
    setuptools.Extension('*',
                         ['grnpy/*.pyx'],
                         include_dirs=include_dirs,
                         library_dirs=library_dirs,
                         libraries=libraries),
]

setuptools.setup(
    packages=setuptools.find_packages(),
    ext_modules=Cython.Build.cythonize(extension),
)
