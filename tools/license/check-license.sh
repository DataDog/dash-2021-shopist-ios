#!/bin/bash

if [ ! -f "LICENSE" ]; then
	echo "\`check-license.sh\` must be run in repository root folder: \`./tools/license/check-license.sh\`"; exit 1
fi

IFS=$'\n'

# Lists all files requiring the license header.
function files {
	# Exclude all auto-generated and 3rd party files.
	find -E . \
		-iregex '.*\.(swift|h|m|py)$' \
		-not -path "*/.build/*"
}

FILES_WITH_MISSING_LICENSE=""

for file in $(files); do
	if ! grep -q "Apache License Version 2.0" "$file"; then
		FILES_WITH_MISSING_LICENSE="${FILES_WITH_MISSING_LICENSE}\n${file}"
	fi
done

if [ -z "$FILES_WITH_MISSING_LICENSE" ]; then
	echo "✅ All files include the license header"
	exit 0
else
	echo -e "🔥 Missing the license header in files: $FILES_WITH_MISSING_LICENSE"
	exit 1
fi
