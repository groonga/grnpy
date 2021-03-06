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

cdef extern from "groonga.h":
    ctypedef enum grn_encoding:
        DEFAULT "GRN_ENC_DEFAULT"
        NONE "GRN_ENC_NONE"
        EUC_JP "GRN_ENC_EUC_JP"
        UTF8 "GRN_ENC_UTF8"
        SJIS "GRN_ENC_SJIS"
        LATIN1 "GRN_ENC_LATIN1"
        KOI8R "GRN_ENC_KOI8R"
