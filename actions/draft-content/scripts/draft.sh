#!/bin/bash

# Script to draft content using OpenAI API
TOPIC="$1"

# Replace with your actual API call using cURL
curl https://api.openai.com/v1/engines/davinci/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "prompt": "Write an introduction for a blog post about '"$TOPIC"'.",
    "max_tokens": 150
  }'
