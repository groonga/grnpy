# Copyright (C) 2026  Abe Tomoaki <abe@clear-code.com>
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

import grnpy

def test_len_empty(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.PatriciaTrie.create('ShortText', 'Users')
        assert len(users) == 0

def test_add_hash(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.HashTable.create('ShortText', 'Users')
        assert users.add('Groonga') == 1
        assert users.add('PGroonga') == 2
        assert len(users) == 2

def test_add_patricia_trie(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.PatriciaTrie.create('ShortText', 'Users')
        assert users.add('Groonga') == 1
        assert users.add('PGroonga') == 2
        assert len(users) == 2

def test_add_array(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.Array.create('Users')
        assert users.add() == 1
        assert users.add() == 2
        assert len(users) == 2

def test_set(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.Array.create('Users', value_type='Int32')
        id = users.add()
        users.set(id, 29)

        assert users.get(id) == 29

def test_cursor_all(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.PatriciaTrie.create('ShortText', 'Users')
        users.add('Groonga')
        users.add('PGroonga')
        users.add('Mroonga')
        with users.open_cursor() as cursor:
            assert list(cursor) == [1, 2, 3]

def test_cursor_limit(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.PatriciaTrie.create('ShortText', 'Users')
        users.add('Groonga')
        users.add('PGroonga')
        users.add('Mroonga')
        with users.open_cursor(limit=1) as cursor:
            assert list(cursor) == [1]

def test_cursor_offset(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.PatriciaTrie.create('ShortText', 'Users')
        users.add('Groonga')
        users.add('PGroonga')
        users.add('Mroonga')
        with users.open_cursor(offset=1) as cursor:
            assert list(cursor) == [2, 3]

def test_cursor_offset_limit(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.PatriciaTrie.create('ShortText', 'Users')
        users.add('Groonga')
        users.add('PGroonga')
        users.add('Mroonga')
        with users.open_cursor(offset=1, limit=1) as cursor:
            assert list(cursor) == [2]
