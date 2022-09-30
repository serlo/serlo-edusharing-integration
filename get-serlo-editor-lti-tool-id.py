#!/usr/bin/env python

from utils import get_current_lti_tool_ids

tool_ids = get_current_lti_tool_ids()

assert len(tool_ids) == 1

print(tool_ids[0])
