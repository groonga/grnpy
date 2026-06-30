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

from grnpy.grn_ctx cimport grn_ctx
from grnpy.grn_id cimport grn_id
from grnpy.grn_obj cimport grn_obj

cdef extern from "groonga.h":
    ctypedef struct grn_table_cursor:
        pass

    cdef int BY_ID "GRN_CURSOR_BY_ID"

    grn_table_cursor *grn_table_cursor_open(grn_ctx *ctx,
                                            grn_obj *table,
                                            const void *min,
                                            unsigned int min_size,
                                            const void *max,
                                            unsigned int max_size,
                                            int offset,
                                            int limit,
                                            int flags)

    grn_id grn_table_cursor_next(grn_ctx *ctx,
                                 grn_table_cursor *cursor)

    void grn_table_cursor_close(grn_ctx *ctx,
                                grn_table_cursor *cursor)
