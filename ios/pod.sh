#!/bin/bash
# Wrapper script to run CocoaPods with Homebrew's portable Ruby 3.3.6

RUBY_PATH="/opt/homebrew/Library/Homebrew/vendor/portable-ruby/3.3.6/bin/ruby"
GEM_PATH="/opt/homebrew/Library/Homebrew/vendor/portable-ruby/3.3.6/bin/gem"
POD_PATH="/opt/homebrew/Library/Homebrew/vendor/portable-ruby/3.3.6/bin/pod"

# Check if the portable Ruby exists
if [ ! -f "$RUBY_PATH" ]; then
    echo "Error: Portable Ruby not found at $RUBY_PATH"
    echo "Please ensure Homebrew is installed correctly."
    exit 1
fi

# Execute pod with all arguments passed through
exec "$POD_PATH" "$@"
