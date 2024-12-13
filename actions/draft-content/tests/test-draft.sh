#!/bin/bash

# Test script for draft-content action

echo "Running draft-content tests..."

# Example test: Check if the draft.sh script exists and is executable
if [ -x ./scripts/draft.sh ]; then
  echo "draft.sh exists and is executable."
else
  echo "draft.sh is missing or not executable."
  exit 1
fi

# Add more tests as needed

echo "All tests passed."
