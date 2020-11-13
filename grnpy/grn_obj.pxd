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

from libc.stdint cimport uint8_t

cdef extern from "groonga.h":
    ctypedef uint8_t grn_obj_type

    cdef grn_obj_type VOID "GRN_VOID"
    cdef grn_obj_type BULK "GRN_BULK"
    cdef grn_obj_type PTR "GRN_PTR"
    cdef grn_obj_type UVECTOR "GRN_UVECTOR"
    cdef grn_obj_type PVECTOR "GRN_PVECTOR"
    cdef grn_obj_type VECTOR "GRN_VECTOR"
    cdef grn_obj_type MSG "GRN_MSG"
    cdef grn_obj_type QUERY "GRN_QUERY"
    cdef grn_obj_type ACCESSOR "GRN_ACCESSOR"
    cdef grn_obj_type SNIP "GRN_SNIP"
    cdef grn_obj_type PATSNIP "GRN_PATSNIP"
    cdef grn_obj_type STRING "GRN_STRING"
    cdef grn_obj_type HIGHLIGHTER "GRN_HIGHLIGHTER"
    cdef grn_obj_type CURSOR_TABLE_HASH_KEY "GRN_CURSOR_TABLE_HASH_KEY"
    cdef grn_obj_type CURSOR_TABLE_PAT_KEY "GRN_CURSOR_TABLE_PAT_KEY"
    cdef grn_obj_type CURSOR_TABLE_DAT_KEY "GRN_CURSOR_TABLE_DAT_KEY"
    cdef grn_obj_type CURSOR_TABLE_NO_KEY "GRN_CURSOR_TABLE_NO_KEY"
    cdef grn_obj_type CURSOR_COLUMN_INDEX "GRN_CURSOR_COLUMN_INDEX"
    cdef grn_obj_type CURSOR_COLUMN_GEO_INDEX "GRN_CURSOR_COLUMN_GEO_INDEX"
    cdef grn_obj_type CURSOR_CONFIG "GRN_CURSOR_CONFIG"
    cdef grn_obj_type TYPE "GRN_TYPE"
    cdef grn_obj_type PROC "GRN_PROC"
    cdef grn_obj_type EXPR "GRN_EXPR"
    cdef grn_obj_type TABLE_HASH_KEY "GRN_TABLE_HASH_KEY"
    cdef grn_obj_type TABLE_PAT_KEY "GRN_TABLE_PAT_KEY"
    cdef grn_obj_type TABLE_DAT_KEY "GRN_TABLE_DAT_KEY"
    cdef grn_obj_type TABLE_NO_KEY "GRN_TABLE_NO_KEY"
    cdef grn_obj_type DB "GRN_DB"
    cdef grn_obj_type COLUMN_FIX_SIZE "GRN_COLUMN_FIX_SIZE"
    cdef grn_obj_type COLUMN_VAR_SIZE "GRN_COLUMN_VAR_SIZE"
    cdef grn_obj_type COLUMN_INDEX "GRN_COLUMN_INDEX"

    ctypedef struct grn_obj:
        pass
