#!/bin/bash

create_service_addon() {
    echo "Adding service addon files"

    echo "Editing $ADDON_FOLDER_NAME/addon.xml"
    echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' > "$ADDON_FOLDER_NAME/addon.xml"
    echo '<addon id="'$ADDON_TYPE.$ADDON_NAME'" name="'$ADDON_NAME'" version="1.0.0" provider-name="">' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '  <requires>' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '    <import addon="xbmc.python" version="3.0.0"/>' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '  </requires>' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '  <extension point="xbmc.service" library="resources/lib/runner.py" />' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '  <extension point="xbmc.addon.metadata">' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '    <platform>all</platform>' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '    <summary lang="en"></summary>' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '  </extension>' >> "$ADDON_FOLDER_NAME/addon.xml"
    echo '</addon>' >> "$ADDON_FOLDER_NAME/addon.xml"

    echo "Editing $ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '# -*- coding: utf-8 -*-' > "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo 'import time' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo 'import xbmc' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo 'if __name__ == "__main__":' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '    monitor = xbmc.Monitor()' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '    while not monitor.abortRequested():' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '        # Sleep/wait for abort for 10 seconds' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '        if monitor.waitForAbort(10):' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '            # Abort was requested while waiting. We should exit' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '            break' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
    echo '        xbmc.executebuiltin('Notification(Hello, World!)')' >> "$ADDON_FOLDER_NAME/resources/lib/runner.py"
}

# Prompt user for addon name and type
read -p "Enter the name of the addon: " ADDON_NAME
echo "Choose the type of addon:"
echo "1. Plugin sources"
echo "2. Repository"
echo "3. Scraper"
echo "4. Scripts"
echo "5. Subtitle"
echo "6. Service"
echo "7. Weather"
echo "8. UI sounds"
read -p "Enter the addon type number: " ADDON_TYPE

# Convert addon type to lowercase and replace spaces with underscores
case $ADDON_TYPE in
    1) ADDON_TYPE="plugin_sources" ;;
    2) ADDON_TYPE="repository" ;;
    3) ADDON_TYPE="scraper" ;;
    4) ADDON_TYPE="scripts" ;;
    5) ADDON_TYPE="subtitle" ;;
    6) ADDON_TYPE="service" ;;
    7) ADDON_TYPE="weather" ;;
    8) ADDON_TYPE="ui_sounds" ;;
    *) echo "Invalid addon type" && exit ;;
esac

# Replace spaces in addon name with underscores and convert to lowercase
ADDON_NAME=$(echo "$ADDON_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Create addon folder
ADDON_FOLDER_NAME="$ADDON_TYPE.$ADDON_NAME"
echo "Creating addon folder $ADDON_FOLDER_NAME"
mkdir -p "$ADDON_FOLDER_NAME"

# Create required addon files and folders
echo "Creating addon files and folders"
# Create the addon folder and required subfolders
mkdir -p "$ADDON_FOLDER_NAME/resources/language"
mkdir -p "$ADDON_FOLDER_NAME/resources/language/English"
mkdir -p "$ADDON_FOLDER_NAME/resources/lib"
mkdir -p "$ADDON_FOLDER_NAME/resources/data"
mkdir -p "$ADDON_FOLDER_NAME/resources/media"

# Create the addon files
touch "$ADDON_FOLDER_NAME/LICENSE.txt"
touch "$ADDON_FOLDER_NAME/resources/settings.xml"
touch "$ADDON_FOLDER_NAME/resources/language/English/strings.po"
touch "$ADDON_FOLDER_NAME/resources/lib/.gitkeep"
touch "$ADDON_FOLDER_NAME/resources/data/.gitkeep"
touch "$ADDON_FOLDER_NAME/resources/media/fanart.jpg"
touch "$ADDON_FOLDER_NAME/resources/media/icon.png"

if [[ "$ADDON_TYPE" == "service" ]]; then
    create_service_addon
fi
