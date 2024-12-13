#!/bin/bash

# Script to generate code using OpenAI API
PROMPT="$1"

# Replace with your actual API call using cURL
curl https://api.openai.com/v1/engines/davinci-codex/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "prompt": "'"$PROMPT"'",
    "max_tokens": 100
  }'
