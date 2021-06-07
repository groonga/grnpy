# Copyright (C) 2021  Sutou Kouhei <kou@clear-code.com>
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
    ctypedef uint32_t grn_column_flags

    cdef grn_column_flags SCALAR "GRN_OBJ_COLUMN_SCALAR"
    cdef grn_column_flags VECTOR "GRN_OBJ_COLUMN_VECTOR"
    cdef grn_column_flags INDEX "GRN_OBJ_COLUMN_INDEX"

    cdef grn_column_flags COMPRESS_NONE "GRN_OBJ_COMPRESS_NONE"
    cdef grn_column_flags COMPRESS_ZLIB "GRN_OBJ_COMPRESS_ZLIB"
    cdef grn_column_flags COMPRESS_LZ4 "GRN_OBJ_COMPRESS_LZ4"
    cdef grn_column_flags COMPRESS_ZSTD "GRN_OBJ_COMPRESS_ZSTD"

    cdef grn_column_flags WITH_SECTION "GRN_OBJ_WITH_SECTION"
    cdef grn_column_flags WITH_WEIGHT "GRN_OBJ_WITH_WEIGHT"
    cdef grn_column_flags WITH_POSITION "GRN_OBJ_WITH_POSITION"

    cdef grn_column_flags INDEX_SMALL "GRN_OBJ_INDEX_SMALL"
    cdef grn_column_flags INDEX_MEDIUM "GRN_OBJ_INDEX_MEDIUM"
    cdef grn_column_flags INDEX_LARGE "GRN_OBJ_INDEX_LARGE"

    cdef grn_column_flags WEIGHT_FLOAT32 "GRN_OBJ_WEIGHT_FLOT32"

    cdef grn_column_flags PERSISTENT "GRN_OBJ_PERSISTENT"

    grn_obj *grn_column_create(grn_ctx *ctx,
                               grn_obj *table,
                               const char *name,
                               unsigned int name_size,
                               const char *path,
                               grn_column_flags flags,
                               grn_obj *type)
