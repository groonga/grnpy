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

from grnpy.grn_ctx cimport grn_ctx
from grnpy.grn_obj cimport grn_obj

cdef extern from "groonga.h":
    ctypedef uint32_t grn_table_flags

    cdef grn_table_flags HASH_KEY "GRN_OBJ_TABLE_HASH_KEY"
    cdef grn_table_flags PAT_KEY "GRN_OBJ_TABLE_PAT_KEY"
    cdef grn_table_flags DAT_KEY "GRN_OBJ_TABLE_DAT_KEY"
    cdef grn_table_flags NO_KEY "GRN_OBJ_TABLE_NO_KEY"

    cdef grn_table_flags KEY_WITH_SIS "GRN_OBJ_KEY_WITH_SIS"

    cdef grn_table_flags PERSISTENT "GRN_OBJ_PERSISTENT"

    grn_obj *grn_table_create(grn_ctx *ctx,
                              const char *name,
                              unsigned int name_size,
                              const char *path,
                              grn_table_flags flags,
                              grn_obj *key_type,
                              grn_obj *value_type)

cdef inline grn_table_flags parse_flags(flags):
    return 0
