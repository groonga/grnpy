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
# distutils: sources = grnpy/grnpy_bulk.c grnpy/grnpy_obj.c

from libc.stdint cimport (
    int8_t,
    int16_t,
    int32_t,
    int64_t,
    uint8_t,
    uint16_t,
    uint32_t,
    uint64_t,
)
from libcpp cimport bool as c_bool

from grnpy.grn_ctx cimport grn_ctx
from grnpy.grn_error cimport grn_rc
from grnpy.grn_id cimport grn_id
from grnpy.grn_obj cimport grn_obj

cimport grnpy.grn_obj
cimport grnpy.grn_type

from grnpy.context cimport Context

from .array import Array
from .database import Database
from .double_array_trie import DoubleArrayTrie
from .error import Error
from .fixed_size_column import FixedSizeColumn
from .hash_table import HashTable
from .patricia_trie import PatriciaTrie
from .type import Type
from .variable_size_column import VariableSizeColumn
import grnpy.initializer

cdef extern from "groonga.h":
    grn_rc grn_obj_close(grn_ctx *ctx, grn_obj *obj)
    void grn_obj_unref(grn_ctx *ctx, grn_obj *obj)
    int grn_obj_name(grn_ctx *ctx, grn_obj *obj, char *buffer, int buffer_size)
    grn_obj *grn_obj_get_value(grn_ctx *ctx, grn_obj *obj, grn_id id, grn_obj *value)

cdef extern from "grnpy_bulk.h":
    void grnpy_bulk_init_void(grn_obj *bulk)
    void grnpy_bulk_rewind(grn_obj *bulk)
    const char *grnpy_bulk_get_head(grn_obj *bulk)
    size_t grnpy_bulk_get_size(grn_obj *bulk)

cdef extern from "grnpy_obj.h":
    uint8_t grnpy_obj_get_type(grn_obj *obj)
    grn_id grnpy_obj_get_domain(grn_obj *obj)
    grn_rc grnpy_obj_set_bool(grn_ctx *ctx, grn_obj *obj, grn_id id, int value)
    grn_rc grnpy_obj_set_int64(grn_ctx *ctx, grn_obj *obj, grn_id id, int64_t value)
    grn_rc grnpy_obj_set_float(grn_ctx *ctx, grn_obj *obj, grn_id id, double value)
    grn_rc grnpy_obj_set_text(grn_ctx *ctx, grn_obj *obj, grn_id id, const char *value, unsigned int length)

cdef class Object:
    def __cinit__(self, *args, **kwargs):
        grnpy_bulk_init_void(&(self._value_buffer))

    def __dealloc__(self):
        cdef Context context
        if self._obj is not NULL:
            context = self._context
            grn_obj_close(context.unwrap(), &(self._value_buffer))
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

    cdef _set_value(self, grn_id id, value):
        cdef Context context = self._context
        cdef grn_ctx *ctx = context.unwrap()
        cdef grn_rc rc
        if isinstance(value, bool):
            rc = grnpy_obj_set_bool(ctx, self.unwrap(), id, value)
        elif isinstance(value, int):
            rc = grnpy_obj_set_int64(ctx, self.unwrap(), id, value)
        elif isinstance(value, float):
            rc = grnpy_obj_set_float(ctx, self.unwrap(), id, value)
        elif isinstance(value, str):
            value_bytes = value.encode(context.encoding_name())
            rc = grnpy_obj_set_text(ctx, self.unwrap(), id, value_bytes, len(value_bytes))
        else:
            raise TypeError(f"unsupported value type: <{type(value)}>")
        Error.check(rc, f"failed to set a value: <{value}>", context.error_message())

    cdef _bulk_to_python(self, grn_obj *bulk):
        cdef Context context = self._context
        cdef grn_id domain = grnpy_obj_get_domain(bulk)
        cdef const char *head = grnpy_bulk_get_head(bulk)
        cdef size_t size = grnpy_bulk_get_size(bulk)
        if size == 0:
            return None
        if domain == grnpy.grn_type.BOOL:
            return (<const c_bool *>head)[0]
        elif domain == grnpy.grn_type.INT8:
            return (<const int8_t *>head)[0]
        elif domain == grnpy.grn_type.UINT8:
            return (<const uint8_t *>head)[0]
        elif domain == grnpy.grn_type.INT16:
            return (<const int16_t *>head)[0]
        elif domain == grnpy.grn_type.UINT16:
            return (<const uint16_t *>head)[0]
        elif domain == grnpy.grn_type.INT32:
            return (<const int32_t *>head)[0]
        elif domain == grnpy.grn_type.UINT32:
            return (<const uint32_t *>head)[0]
        elif domain == grnpy.grn_type.INT64:
            return (<const int64_t *>head)[0]
        elif domain == grnpy.grn_type.UINT64:
            return (<const uint64_t *>head)[0]
        elif domain == grnpy.grn_type.FLOAT32:
            return (<const float *>head)[0]
        elif domain == grnpy.grn_type.FLOAT:
            return (<const double *>head)[0]
        elif domain in (grnpy.grn_type.SHORT_TEXT,
                        grnpy.grn_type.TEXT,
                        grnpy.grn_type.LONG_TEXT):
            return head[:size].decode(context.encoding_name())
        else:
            raise NotImplementedError(f"unsupported value type: <{domain}>")

    cdef _get_value(self, grn_id id):
        cdef Context context = self._context
        cdef grn_ctx *ctx = context.unwrap()
        grnpy_bulk_rewind(&(self._value_buffer))
        grn_obj_get_value(ctx, self.unwrap(), id, &(self._value_buffer))
        context.check(f"failed to get a value: <{id}>")
        return self._bulk_to_python(&(self._value_buffer))

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
        grn_obj_close(context.unwrap(), &(self._value_buffer))
        grn_obj_close(context.unwrap(), self._obj)
        self._obj = NULL
        self._context = None

    def __enter__(self):
        return self

    def __exit__(self, type, value, traceback):
        self.close()

def resolve_class(uint8_t type):
    if type == grnpy.grn_obj.TABLE_NO_KEY:
        return Array
    elif type == grnpy.grn_obj.TABLE_HASH_KEY:
        return HashTable
    elif type == grnpy.grn_obj.TABLE_PAT_KEY:
        return PatriciaTrie
    elif type == grnpy.grn_obj.TABLE_DAT_KEY:
        return DoubleArrayTrie
    elif type == grnpy.grn_obj.COLUMN_FIX_SIZE:
        return FixedSizeColumn
    elif type == grnpy.grn_obj.COLUMN_VAR_SIZE:
        return VariableSizeColumn
    elif type == grnpy.grn_obj.TYPE:
        return Type
    elif type == grnpy.grn_obj.DB:
        return Database
    else:
        raise NotImplementedError(f"unsupported type: {type}")

cdef build_object(Context context, grn_obj *obj):
    cls = resolve_class(grnpy_obj_get_type(obj))
    cdef Object object
    object = cls()
    object._context = context
    object._obj = obj
    return object
