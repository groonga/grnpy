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

grn_rc grnpy_ctx_get_rc(grn_ctx *ctx);
const char *grnpy_ctx_get_error_message(grn_ctx *ctx);
