# Copyright (C) 2026  Abe Tomoaki <abe@clear-code.com>
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

from grnpy.grn_id cimport grn_id

cdef extern from "groonga.h":
    cdef grn_id VOID "GRN_DB_VOID"
    cdef grn_id BOOL "GRN_DB_BOOL"
    cdef grn_id INT8 "GRN_DB_INT8"
    cdef grn_id UINT8 "GRN_DB_UINT8"
    cdef grn_id INT16 "GRN_DB_INT16"
    cdef grn_id UINT16 "GRN_DB_UINT16"
    cdef grn_id INT32 "GRN_DB_INT32"
    cdef grn_id UINT32 "GRN_DB_UINT32"
    cdef grn_id INT64 "GRN_DB_INT64"
    cdef grn_id UINT64 "GRN_DB_UINT64"
    cdef grn_id FLOAT "GRN_DB_FLOAT"
    cdef grn_id FLOAT32 "GRN_DB_FLOAT32"
    cdef grn_id SHORT_TEXT "GRN_DB_SHORT_TEXT"
    cdef grn_id TEXT "GRN_DB_TEXT"
    cdef grn_id LONG_TEXT "GRN_DB_LONG_TEXT"
