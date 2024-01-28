extends Node


# Exhaustive check to see if an object still exists.
static func object_exists(object):
  return !!weakref(object).get_ref() and is_instance_valid(object)
