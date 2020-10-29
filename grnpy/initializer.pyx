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

# cython: language_level = 3

from grnpy.grn_error cimport grn_rc
from .error import Error

cdef extern from "groonga.h":
    grn_rc grn_init()
    grn_rc grn_fin()

class Initializer:
    def __init__(self):
        Error.check(grn_init(), "failed to initialize Groonga")

    def __del__(self):
        Error.check(grn_fin(), "failed to finalize Groonga")

_instance = None
def instance():
    global _instance
    if _instance is None:
        _instance = Initializer()
    return _instance
