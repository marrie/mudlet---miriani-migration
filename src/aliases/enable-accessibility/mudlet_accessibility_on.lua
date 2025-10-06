echo("Welcome to Mudlet!\n")
echo("Let's adjust a few preferences to improve the visually impaired experience:\n")

setConfig("autoClearInputLine", true)
echo("Text will now be removed from the input line after it was sent ✓\n")
setConfig("showSentText", false)
echo("Text sent to the game will not appear in the main window ✓\n")

setConfig("caretShortcut", "ctrltab")
echo("Shortcut to switch between input line and main window set to Ctrl+Tab. You can also change it to either Tab or F6 in settings.\n")

if getOS() == "windows" then
  setConfig("blankLinesBehaviour", "hide")
  echo("Blank lines will be removed from the output ✓\n")
end

if getOS() == "mac" then
  echo("\nYou're on a mac and VoiceOver will skip reading text when there's lots of it coming in. Would you like to install a third-party TTS plugin to alleviate this issue?\n")
  echo("Type 'mudlet access reader' if so.\n")
  echo("See https://wiki.mudlet.org/w/Accessibility_on_OSX if you'd like to learn more.\n")
end

echo("\nThat's all, enjoy Mudlet!\n")