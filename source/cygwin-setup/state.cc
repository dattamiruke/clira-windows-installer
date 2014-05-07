/*
 * Copyright (c) 2000, Red Hat, Inc.
 *
 *     This program is free software; you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation; either version 2 of the License, or
 *     (at your option) any later version.
 *
 *     A copy of the GNU General Public License can be found at
 *     http://www.gnu.org/
 *
 * Written by DJ Delorie <dj@cygnus.com>
 *
 */

/* All we do here is instantiate the extern'd variables from state.h */

#if 0
static const char *cvsid =
  "\n%%% $Id: state.cc,v 2.8 2013/11/15 10:22:16 corinna Exp $\n";
#endif

#include "state.h"

enum attend_mode unattended_mode = attended;
bool rebootneeded;

int source;

std::string local_dir;

int root_scope;
int root_menu;
int root_desktop;
