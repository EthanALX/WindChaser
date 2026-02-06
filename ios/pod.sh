#!/bin/bash
# Wrapper script to run CocoaPods with Homebrew's Ruby

POD_PATH="/opt/homebrew/lib/ruby/gems/4.0.0/bin/pod"

# Check if pod exists
if [ ! -f "$POD_PATH" ]; then
    echo "Error: CocoaPods not found at $POD_PATH"
    echo "Please install CocoaPods with: /opt/homebrew/opt/ruby/bin/gem install cocoapods"
    exit 1
fi

# Execute pod with all arguments passed through
exec "$POD_PATH" "$@"
