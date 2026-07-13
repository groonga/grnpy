/*
  Copyright (C) 2026  Abe Tomoaki <abe@clear-code.com>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this program.  If not, see
  <http://www.gnu.org/licenses/>.
*/

#pragma once

#include <groonga.h>

void grnpy_bulk_init_void(grn_obj *bulk);
void grnpy_bulk_rewind(grn_obj *bulk);

const char *grnpy_bulk_get_head(grn_obj *bulk);
size_t grnpy_bulk_get_size(grn_obj *bulk);
