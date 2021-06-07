# Copyright (C) 2020-2021  Sutou Kouhei <kou@clear-code.com>
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

cimport grnpy.grn_column

from grnpy.context cimport Context
from grnpy.object cimport Object, build_object
from grnpy.table cimport Table

from .error import Error
import grnpy.context

cdef class Table:
    def _create_column(self,
                       name,
                       path,
                       grnpy.grn_column.grn_column_flags flags,
                       Object value_type):
        name_original = name
        if isinstance(name, str):
            name = name.encode()
        cdef const char *name_c
        cdef unsigned int name_c_size
        if name is None:
            name_c = NULL
            name_c_size = 0
        else:
            name_c = name
            name_c_size = len(name)
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
        value_type_c = value_type.unwrap()
        cdef Context context = self._context
        column = grnpy.grn_column.grn_column_create(context.unwrap(),
                                                    self.unwrap(),
                                                    name_c,
                                                    name_c_size,
                                                    path_c,
                                                    flags,
                                                    value_type_c)
        if column is NULL:
            self._context.check(f"failed to create column: <{name_original}>")
        return build_object(self._context, column)

    def create_scalar_column(self,
                             name,
                             value_type,
                             persistent=True,
                             path=None,
                             compression=None):
        flags = grnpy.grn_column.SCALAR
        if persistent:
            flags |= grnpy.grn_column.PERSISTENT
        if compression == 'zlib':
            flags |= grnpy.grn_column.COMPRESS_ZLIB
        elif compression == 'lz4':
            flags |= grnpy.grn_column.COMPRESS_LZ4
        elif compression == 'zstd':
            flags |= grnpy.grn_column.COMPRESS_ZSTD
        elif compression is not None:
            message = \
                f'compression must be one of ' + \
                f'\'zlib\', \'lz4\', \'zstd\' or None: <{compression}>'
            raise ValueError, message
        if isinstance(value_type, str):
            value_type = self._context[value_type]
        return self._create_column(name,
                                   path,
                                   flags,
                                   value_type)
