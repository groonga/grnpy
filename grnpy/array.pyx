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

import os

from grnpy.grn_ctx cimport grn_ctx
from grnpy.grn_error cimport grn_rc
from grnpy.grn_obj cimport grn_obj

cimport grnpy.grn_table

from grnpy.context cimport Context
from grnpy.object cimport Object, build_object
from grnpy.table cimport Table

from .error import Error
import grnpy.context

cdef class Array(Table):
    @classmethod
    def create(cls,
               name=None,
               flags=[],
               path=None,
               Object value_type=None,
               Context context=None):
        if context is None:
            context = grnpy.context.default()
        name_original = name
        if isinstance(name, str):
            name = name.encode()
        cdef const char *name_c
        cdef unsigned int name_c_size
        flags_c = grnpy.grn_table.parse_flags(flags) | grnpy.grn_table.NO_KEY
        if name is None:
            name_c = NULL
            name_c_size = 0
        else:
            name_c = name
            name_c_size = len(name)
            flags_c |= grnpy.grn_table.PERSISTENT
        if path is not None:
            path = os.fspath(path)
        if isinstance(path, str):
            path = path.encode()
        cdef const char *path_c
        if path is None:
            path_c = NULL
        else:
            path_c = path
        cdef grn_obj *value_type_c
        if value_type is None:
            value_type_c = NULL
        else:
            value_type_c = value_type.unwrap()
        array = grnpy.grn_table.grn_table_create(context.unwrap(),
                                                 name_c,
                                                 name_c_size,
                                                 path_c,
                                                 flags_c,
                                                 NULL,
                                                 value_type_c)
        if array is NULL:
            context.check(f"failed to create array: <{name_original}>")
        return build_object(context, array)
