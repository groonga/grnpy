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

import os
import re
import subprocess
import sys

import setuptools

import Cython.Build

with open('grnpy/__init__.py') as init_py:
    version = re.search('__version__ = \'(.*?)\'',
                        init_py.read())[1]

with open('README.md') as readme:
    long_description = readme.read()

glob = Cython.Build.Dependencies.extended_iglob

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
    name='grnpy',
    version=version,
    packages=setuptools.find_packages(),
    description='Fast full text search library based on Groonga',
    long_description=long_description,
    long_description_content_type='text/markdown',
    ext_modules=Cython.Build.cythonize(extension),
    install_requires=[
        'pyarrow',
    ],
    python_requires='>=3',
    tests_require=[
        'pytest',
    ],
    author='Sutou Kouhei',
    author_email='kou@clear-code.com',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'License :: OSI Approved :: GNU Lesser General Public License v3 or later (LGPLv3+)',
        'Intended Audience :: Developers',
        'Intended Audience :: Information Technology',
        'Intended Audience :: Science/Research',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Operating System :: MacOS :: MacOS X',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: POSIX :: Linux',
        'Topic :: Scientific/Engineering :: Information Analysis',
        'Topic :: Text Processing :: Indexing',
        'Topic :: Text Processing :: Linguistic',
    ],
    license="LGPLv3+",
    url='https://github.com/groonga/grnpy',
    project_urls={
        'Source': 'https://github.com/groonga/grnpy',
        'Tracker': 'https://github.com/groonga/grnpy/issues',
    },
)
