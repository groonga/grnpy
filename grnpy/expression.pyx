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

import os

from grnpy.grn_ctx cimport grn_ctx
from grnpy.grn_error cimport grn_rc
from grnpy.grn_obj cimport grn_obj

cimport grnpy.grn_expr

from grnpy.context cimport Context
from grnpy.object cimport Object, build_object
from grnpy.table cimport Table

from .error import Error
import grnpy.context

cdef class Expression(Object):
    def __cinit__(self, Context context=None, name=None):
        if context is None:
            context = grnpy.context.default()
        self._context = context
        cdef const char *name_c
        cdef unsigned int name_size_c
        if name is None:
            name_c = NULL
            name_size_c = 0
        else:
            name_c = name
            name_size_c = len(name)
        self._obj = grnpy.grn_expr.grn_expr_create(context.unwrap(),
                                                   name_c,
                                                   name_size_c)
        if self._obj is NULL:
            context.check(f"failed to create expression")
