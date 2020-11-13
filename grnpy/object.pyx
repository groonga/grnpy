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

from grnpy.grn_ctx cimport grn_ctx
from grnpy.grn_error cimport grn_rc
from grnpy.grn_obj cimport grn_obj

from grnpy.context cimport Context

from .error import Error
import grnpy.initializer

cdef extern from "groonga.h":
    void grn_obj_unref(grn_ctx *ctx, grn_obj *obj)

cdef class Object:
    def __dealloc__(self):
        cdef Context context
        if self._obj is not NULL:
            context = self._context
            grn_obj_unref(context.unwrap(), self._obj)
            self._obj = NULL
        self._context = None

    cdef grn_obj *unwrap(self):
        return self._obj

cdef build_object(cls, Context context, grn_obj *obj):
    cdef Object object
    object = cls()
    object._context = context
    object._obj = obj
    return object
