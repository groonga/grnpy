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
from grnpy.grn_id cimport grn_id, NIL

from grnpy.grn_table_cursor cimport (
    BY_ID,
    grn_table_cursor,
    grn_table_cursor_open,
    grn_table_cursor_next,
    grn_table_cursor_close
)

from grnpy.context cimport Context
from grnpy.table cimport Table

cdef class TableCursor:
    def __init__(self, Table table, offset=0, limit=-1):
        cdef Context context = table._context
        self._context = context
        self._cursor = grn_table_cursor_open(context.unwrap(),
                                             table.unwrap(),
                                             NULL,
                                             0,
                                             NULL,
                                             0,
                                             offset,
                                             limit,
                                             BY_ID)
        if self._cursor is NULL:
            context.check("failed to open table cursor")

    def __iter__(self):
        return self

    def __next__(self):
        cdef Context context = self._context
        if self._cursor is NULL:
            raise StopIteration
        cdef grn_id id = grn_table_cursor_next(context.unwrap(), self._cursor)
        if id == NIL:
            raise StopIteration
        return id

    def close(self):
        cdef Context context = self._context
        if self._cursor is NULL:
            return
        grn_table_cursor_close(context.unwrap(), self._cursor)
        self._cursor = NULL

    def __enter__(self):
        return self

    def __exit__(self, type, value, traceback):
        self.close()

    def __dealloc__(self):
        self.close()
