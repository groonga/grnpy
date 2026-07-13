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

#include <groonga.h>

uint8_t
grnpy_obj_get_type(grn_obj *obj)
{
  return obj->header.type;
}

grn_id
grnpy_obj_get_domain(grn_obj *obj)
{
  return obj->header.domain;
}

grn_rc
grnpy_obj_set_bool(grn_ctx *ctx, grn_obj *obj, grn_id id, int value)
{
  grn_obj value_buffer;
  GRN_BOOL_INIT(&value_buffer, 0);
  GRN_BOOL_SET(ctx, &value_buffer, value);
  grn_rc rc = grn_obj_set_value(ctx, obj, id, &value_buffer, GRN_OBJ_SET);
  GRN_OBJ_FIN(ctx, &value_buffer);
  return rc;
}

grn_rc
grnpy_obj_set_int64(grn_ctx *ctx, grn_obj *obj, grn_id id, int64_t value)
{
  grn_obj value_buffer;
  GRN_INT64_INIT(&value_buffer, 0);
  GRN_INT64_SET(ctx, &value_buffer, value);
  grn_rc rc = grn_obj_set_value(ctx, obj, id, &value_buffer, GRN_OBJ_SET);
  GRN_OBJ_FIN(ctx, &value_buffer);
  return rc;
}

grn_rc
grnpy_obj_set_float(grn_ctx *ctx, grn_obj *obj, grn_id id, double value)
{
  grn_obj value_buffer;
  GRN_FLOAT_INIT(&value_buffer, 0);
  GRN_FLOAT_SET(ctx, &value_buffer, value);
  grn_rc rc = grn_obj_set_value(ctx, obj, id, &value_buffer, GRN_OBJ_SET);
  GRN_OBJ_FIN(ctx, &value_buffer);
  return rc;
}

grn_rc
grnpy_obj_set_text(grn_ctx *ctx, grn_obj *obj, grn_id id, const char *value, unsigned int length)
{
  grn_obj value_buffer;
  GRN_TEXT_INIT(&value_buffer, GRN_OBJ_DO_SHALLOW_COPY);
  GRN_TEXT_SET(ctx, &value_buffer, value, length);
  grn_rc rc = grn_obj_set_value(ctx, obj, id, &value_buffer, GRN_OBJ_SET);
  GRN_OBJ_FIN(ctx, &value_buffer);
  return rc;
}
