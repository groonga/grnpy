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

from grnpy.context import Context
import grnpy.context

from grnpy.array import Array
from grnpy.database import Database
from grnpy.double_array_trie import DoubleArrayTrie
from grnpy.hash_table import HashTable
from grnpy.patricia_trie import PatriciaTrie

import grnpy.rc

def find(name_or_id):
    return grnpy.context.default()[name_or_id]

__version__ = '10.0.7'
