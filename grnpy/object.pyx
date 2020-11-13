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
# distutils: sources = grnpy/grnpy_obj.c

from libc.stdint cimport uint8_t

from grnpy.grn_ctx cimport grn_ctx
from grnpy.grn_error cimport grn_rc
from grnpy.grn_obj cimport grn_obj

cimport grnpy.grn_obj

from grnpy.context cimport Context

from .array import Array
from .database import Database
from .error import Error
import grnpy.initializer

cdef extern from "groonga.h":
    grn_rc grn_obj_close(grn_ctx *ctx, grn_obj *obj)
    void grn_obj_unref(grn_ctx *ctx, grn_obj *obj)
    int grn_obj_name(grn_ctx *ctx, grn_obj *obj, char *buffer, int buffer_size)

cdef extern from "grnpy_obj.h":
    uint8_t grnpy_obj_get_type(grn_obj *obj)

cdef class Object:
    def __dealloc__(self):
        cdef Context context
        if self._obj is not NULL:
            context = self._context
            # TODO: This may be not worked when a database is closed
            # and a table in the database isn't deleted yet.
            grn_obj_unref(context.unwrap(), self._obj)
            self._obj = NULL
        self._context = None

    cdef grn_obj *unwrap(self):
        return self._obj

    def type(self):
        return grnpy_obj_get_type(self._obj)

    def name(self):
        cdef Context context = self._context
        # TODO: GRN_TABLE_MAX_KEY_SIZE
        cdef char[4096] name_buffer
        name_length = grn_obj_name(context.unwrap(),
                                   self._obj,
                                   name_buffer,
                                   4096)
        return name_buffer[:name_length].decode('utf-8')

    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return False
        cdef Object other_ = other
        return self._obj == other_._obj

    def close(self):
        cdef Context context = self._context
        if self._obj is NULL:
            return
        if context is None:
            return
        grn_obj_close(context.unwrap(), self._obj)
        self._obj = NULL
        self._context = None

def resolve_class(uint8_t type):
    if type == grnpy.grn_obj.TABLE_NO_KEY:
        return Array
    elif type == grnpy.grn_obj.DB:
        return Database
    else:
        raise NotImplemented(f"unsupported type: {type}")

cdef build_object(Context context, grn_obj *obj):
    cls = resolve_class(grnpy_obj_get_type(obj))
    cdef Object object
    object = cls()
    object._context = context
    object._obj = obj
    return object
