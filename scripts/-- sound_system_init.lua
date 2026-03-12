-- sound_system_init.lua

-- Determine Mudlet data directory so all sound file paths can be built
-- dynamically instead of hardcoding filesystem paths.
-- This allows the package to work on different machines.


sound_base_path = getMudletHomeDir()


-- Temporary debug output used during early development.
-- Safe to remove once path construction is verified.

print("[sound init] Sound base path:", sound_base_path)