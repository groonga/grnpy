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

from grnpy.grn_error cimport grn_rc

cdef extern from "groonga.h":
    const char *grn_rc_to_string(grn_rc)

class Error(Exception):
    @classmethod
    def check(self, rc, user_message=None):
        if rc != grn_rc.SUCCESS:
            raise self(rc, user_message)

    def __init__(self, rc, user_message=None):
        self.rc = rc
        self.user_message = user_message
        self.message = grn_rc_to_string(self.rc)

    def __str__(self):
        f"{self.rc}: {self.message}: {self.user_message}"
