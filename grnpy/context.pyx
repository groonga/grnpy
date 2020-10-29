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

from grnpy.grn_context cimport grn_ctx
from grnpy.grn_error cimport grn_rc

from .error import Error
import grnpy.initializer

cdef extern from "groonga.h":
    grn_ctx *grn_ctx_open(int flags)
    grn_rc grn_ctx_close(grn_ctx *ctx)

cdef class Context:
    cdef object _initializer
    cdef grn_ctx *_ctx

    def __cinit__(self, flags=0):
        self._initializer = grnpy.initializer.instance()
        self._ctx = grn_ctx_open(flags)
        if self._ctx is NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._ctx is not NULL:
            Error.check(grn_ctx_close(self._ctx))
            self._ctx = NULL
        self._initializer = None
