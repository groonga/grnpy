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

from libc.stdint cimport uint32_t

cdef extern from "groonga.h":
    ctypedef uint32_t grn_id
    cdef grn_id NIL "GRN_ID_NIL"
    cdef grn_id MAX "GRN_ID_MAX"

    cdef grn_id BOOL "GRN_DB_BOOL"
    cdef grn_id FLOAT "GRN_DB_FLOAT"
    cdef grn_id INT64 "GRN_DB_INT64"
    cdef grn_id TEXT "GRN_DB_TEXT"
