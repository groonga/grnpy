/*
  Copyright (C) 2020  Sutou Kouhei <kou@clear-code.com>

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

uint8_t grnpy_obj_get_type(grn_obj *obj);
grn_rc grnpy_obj_set_bool(grn_ctx *ctx, grn_obj *obj, grn_id id, int value);
grn_rc grnpy_obj_set_int64(grn_ctx *ctx, grn_obj *obj, grn_id id, int64_t value);
grn_rc grnpy_obj_set_float(grn_ctx *ctx, grn_obj *obj, grn_id id, double value);
grn_rc grnpy_obj_set_text(grn_ctx *ctx, grn_obj *obj, grn_id id, const char *value, unsigned int length);
