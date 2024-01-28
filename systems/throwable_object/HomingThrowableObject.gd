class_name HomingThrowableObject
extends ThrowableObject


# Get nodes in homing_targets group
# Filter to ones that are on-screen
# If there are > 1 (more than just the player)
# - Home in on closest non-player target
# Else if there is only 1 node in the group (the player)
# - Home on the player, but in a way that the player can dodge
# While aiming, use UI to show which target is being homed in on


