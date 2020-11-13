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

import pytest

import grnpy

def test_rc():
    context = grnpy.Context()
    assert context.rc() == grnpy.rc.SUCCESS

def test_find(tmpdir):
    db_path = tmpdir.join("db")
    database = grnpy.Database.create(db_path)
    try:
        array = grnpy.Array.create("Users")
        assert grnpy.find("Users") == array
    finally:
        database.close()
