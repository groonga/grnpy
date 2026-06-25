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

from libc.stdint cimport int64_t

from grnpy.context cimport Context
from grnpy.grn_bulk cimport grn_bulk_write_from
from grnpy.grn_ctx cimport grn_ctx
from grnpy.grn_error cimport grn_rc
from grnpy.grn_id cimport BOOL, FLOAT, INT64, TEXT, grn_id
from grnpy.grn_obj cimport BULK, SET, grn_obj, grn_obj_open, grn_obj_set_value, grn_obj_close
from grnpy.object cimport Object

cdef class Column(Object):
    cdef grn_obj *_to_grn_obj(self, value) except NULL:
        cdef Context context = self._context
        cdef grn_ctx *ctx = context.unwrap()

        cdef grn_obj *value_c
        cdef int64_t int_value
        cdef double float_value
        cdef char bool_value

        if isinstance(value, bool):
            value_c = grn_obj_open(ctx, BULK, 0, BOOL)
            if value_c is not NULL:
                bool_value = value
                grn_bulk_write_from(ctx, value_c, <char *>&bool_value, 0, sizeof(bool_value))
        elif isinstance(value, int):
            value_c = grn_obj_open(ctx, BULK, 0, INT64)
            if value_c is not NULL:
                int_value = value
                grn_bulk_write_from(ctx, value_c, <char *>&int_value, 0, sizeof(int_value))
        elif isinstance(value, float):
            value_c = grn_obj_open(ctx, BULK, 0, FLOAT)
            if value_c is not NULL:
                float_value = value
                grn_bulk_write_from(ctx, value_c, <char *>&float_value, 0, sizeof(float_value))
        elif isinstance(value, str):
            value_bytes = value.encode()
            value_c = grn_obj_open(ctx, BULK, 0, TEXT)
            if value_c is not NULL:
                grn_bulk_write_from(ctx, value_c, value_bytes, 0, len(value_bytes))
        else:
            raise TypeError(f"unsupported value type: <{type(value)}>")
        if value_c is NULL:
            raise MemoryError()

        return value_c

    def set(self, grn_id id, value):
        cdef Context context = self._context
        cdef grn_ctx *ctx = context.unwrap()

        cdef grn_obj *value_c = self._to_grn_obj(value)
        try:
            grn_obj_set_value(ctx, self.unwrap(), id, value_c, SET)
            context.check(f"failed to set a value: <{value}>")
        finally:
            grn_obj_close(ctx, value_c)
