#!/usr/bin/env python

from utils import get_current_lti_tool_ids

tool_ids = get_current_lti_tool_ids()

print(tool_ids[0] if len(tool_ids) > 0 else "foo")
