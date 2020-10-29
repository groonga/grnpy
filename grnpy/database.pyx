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
from grnpy.object cimport Object, build_object

from .error import Error
import grnpy.context

cdef extern from "groonga.h":
    ctypedef struct grn_db_create_optarg:
        pass

    grn_obj *grn_db_create(grn_ctx *ctx,
                           const char *path,
                           grn_db_create_optarg *optarg)
    grn_obj *grn_db_open(grn_ctx *ctx,
                         const char *path)

cdef class Database(Object):
    @classmethod
    def create(cls, path=None, Context context=None):
        if context is None:
            context = grnpy.context.default()
        if isinstance(path, str):
            path = path.encode()
        db = grn_db_create(context.unwrap(), path, NULL)
        if db is NULL:
            context.check(f"failed to create database: <{path}>")
        return build_object(cls, context, db)

    @classmethod
    def open(cls, path, Context context=None):
        if context is None:
            context = grnpy.context.default()
        db = grn_db_open(context.unwrap(), path)
        if db is NULL:
            context.check(f"failed to open database: <{path}>")
        return build_object(cls, context, db)
