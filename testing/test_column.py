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

def test_set_value(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.PatriciaTrie.create('ShortText', 'Users')
        age = users.create_scalar_column('age', 'Int32')
        weight = users.create_scalar_column('weight', 'Float')
        address = users.create_scalar_column('address', 'ShortText')
        active = users.create_scalar_column('active', 'Bool')

        id = users.add('Groonga')
        age.set(id, 20)
        weight.set(id, 70.5)
        active.set(id, True)
        address.set(id, 'Tokyo')

        assert age.get(id) == 20
        assert weight.get(id) == 70.5
        assert active.get(id) is True
        assert address.get(id) == 'Tokyo'

def test_get_no_data(tmpdir):
    db_path = tmpdir.join('db')
    with grnpy.Database.create(db_path):
        users = grnpy.PatriciaTrie.create('ShortText', 'Users')
        age = users.create_scalar_column('age', 'Int32')
        weight = users.create_scalar_column('weight', 'Float')
        address = users.create_scalar_column('address', 'ShortText')
        active = users.create_scalar_column('active', 'Bool')

        id = users.add('Groonga')

        assert age.get(id) == 0
        assert weight.get(id) == 0.0
        assert active.get(id) is False
        assert address.get(id) is None
