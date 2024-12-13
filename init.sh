#!/bin/bash

# Script to initialize the openai-actions repository structure

# Exit immediately if a command exits with a non-zero status
set -e

# Variables (Customize these before running the script)
REPO_NAME="openai-actions"
YEAR=$(date +"%Y")
AUTHOR="Your Name"  # Replace with your name or organization

# Function to create directories
create_dirs() {
  mkdir -p "$REPO_NAME"/{actions/{generate-code,draft-content}/{scripts,tests},examples,scripts,docs,.github/{workflows,ISSUE_TEMPLATE},tests/{integration,unit}}
}

# Function to create root files
create_root_files() {
  # README.md
  cat <<EOL > "$REPO_NAME/README.md"
# openai-actions

Open-source GitHub Actions for integrating the OpenAI API into your CI/CD workflows. Automate AI-driven tasks like code generation, content creation, and more.

## Getting Started

Include instructions on how to use the repository.

## Actions

- [Generate Code](./actions/generate-code/README.md)
- [Draft Content](./actions/draft-content/README.md)
- ...

## Examples

See the [examples](./examples/) directory for sample workflows.

## Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
EOL

  # LICENSE (MIT)
  cat <<EOL > "$REPO_NAME/LICENSE"
MIT License

Copyright (c) $YEAR $AUTHOR

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

[Full MIT License text here]
EOL

  # CONTRIBUTING.md
  cat <<EOL > "$REPO_NAME/CONTRIBUTING.md"
# Contributing to openai-actions

We welcome contributions! Please read the [guidelines](./docs/contributing.md) before getting started.
EOL
}

# Function to create GitHub workflow files
create_github_workflows() {
  # CI Workflow
  cat <<EOL > "$REPO_NAME/.github/workflows/ci.yml"
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - name: Run Tests
        run: echo "Running tests..."
        # Add actual test commands here
EOL

  # Release Workflow
  cat <<EOL > "$REPO_NAME/.github/workflows/release.yml"
name: Release

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  release:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - name: Create Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: \${{ github.ref }}
          release_name: Release \${{ github.ref }}
          draft: false
          prerelease: false
EOL

  # Issue Templates
  cat <<EOL > "$REPO_NAME/.github/ISSUE_TEMPLATE/bug_report.md"
---
name: Bug Report
about: Create a report to help us improve
title: ""
labels: bug
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. 
2. 
3. 

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Additional context**
Add any other context about the problem here.
EOL

  cat <<EOL > "$REPO_NAME/.github/ISSUE_TEMPLATE/feature_request.md"
---
name: Feature Request
about: Suggest an idea for this project
title: ""
labels: enhancement
assignees: ''

---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
EOL

  # Pull Request Template
  cat <<EOL > "$REPO_NAME/.github/PULL_REQUEST_TEMPLATE.md"
## Description

Please include a summary of the change and which issue is fixed. 

Fixes #(issue)

## Type of change

- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Other (please specify)

## How Has This Been Tested?

Please describe the tests that you ran to verify your changes.

## Checklist:

- [ ] My code follows the style guidelines of this project.
- [ ] I have performed a self-review of my own code.
- [ ] I have commented my code, particularly in hard-to-understand areas.
- [ ] I have made corresponding changes to the documentation.
- [ ] My changes generate no new warnings.
- [ ] I have added tests that prove my fix is effective or that my feature works.
- [ ] New and existing unit tests pass locally with my changes.
EOL
}

# Function to create example workflows
create_examples() {
  # Example Workflow 1
  cat <<EOL > "$REPO_NAME/examples/workflow-example-1.yml"
name: Example Workflow 1

on: [push]

jobs:
  example:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Generate Code
        uses: ./actions/generate-code
      - name: Draft Content
        uses: ./actions/draft-content
EOL

  # Example Workflow 2
  cat <<EOL > "$REPO_NAME/examples/workflow-example-2.yml"
name: Example Workflow 2

on: [pull_request]

jobs:
  example:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Generate Code
        uses: ./actions/generate-code
EOL

  # Examples README
  cat <<EOL > "$REPO_NAME/examples/README.md"
# Examples

This directory contains example GitHub Actions workflows demonstrating how to use the actions in this repository.

## Workflow Example 1

\`workflow-example-1.yml\` shows how to generate code and draft content in a single workflow.

## Workflow Example 2

\`workflow-example-2.yml\` demonstrates generating code upon a pull request.
EOL
}

# Function to create action definitions
create_actions() {
  # Generate Code Action
  cat <<EOL > "$REPO_NAME/actions/generate-code/action.yml"
name: Generate Code

description: Uses OpenAI API to generate code based on provided inputs.

inputs:
  prompt:
    description: 'The prompt to generate code.'
    required: true
    type: string

outputs:
  generated_code:
    description: 'The code generated by OpenAI.'

runs:
  using: 'composite'
  steps:
    - name: Generate Code
      shell: bash
      run: |
        ./scripts/generate.sh "\${{ inputs.prompt }}"
EOL

  cat <<EOL > "$REPO_NAME/actions/generate-code/README.md"
# Generate Code Action

This GitHub Action integrates with the OpenAI API to generate code based on a given prompt.

## Inputs

- **prompt** (required): The prompt to generate code.

## Outputs

- **generated_code**: The code generated by OpenAI.

## Usage

\`\`\`yaml
- name: Generate Code
  uses: ./actions/generate-code
  with:
    prompt: "Create a Python function to reverse a string."
\`\`\`

## License

This action is licensed under the MIT License.
EOL

  cat <<'EOL' > "$REPO_NAME/actions/generate-code/scripts/generate.sh"
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
EOL
  chmod +x "$REPO_NAME/actions/generate-code/scripts/generate.sh"

  cat <<EOL > "$REPO_NAME/actions/generate-code/tests/test-generate.sh"
#!/bin/bash

# Test script for generate-code action

echo "Running generate-code tests..."

# Example test: Check if the generate.sh script exists and is executable
if [ -x ./scripts/generate.sh ]; then
  echo "generate.sh exists and is executable."
else
  echo "generate.sh is missing or not executable."
  exit 1
fi

# Add more tests as needed

echo "All tests passed."
EOL
  chmod +x "$REPO_NAME/actions/generate-code/tests/test-generate.sh"

  # Draft Content Action
  cat <<EOL > "$REPO_NAME/actions/draft-content/action.yml"
name: Draft Content

description: Uses OpenAI API to draft content based on provided inputs.

inputs:
  topic:
    description: 'The topic to draft content about.'
    required: true
    type: string

outputs:
  drafted_content:
    description: 'The content drafted by OpenAI.'

runs:
  using: 'composite'
  steps:
    - name: Draft Content
      shell: bash
      run: |
        ./scripts/draft.sh "\${{ inputs.topic }}"
EOL

  cat <<EOL > "$REPO_NAME/actions/draft-content/README.md"
# Draft Content Action

This GitHub Action integrates with the OpenAI API to draft content based on a given topic.

## Inputs

- **topic** (required): The topic to draft content about.

## Outputs

- **drafted_content**: The content drafted by OpenAI.

## Usage

\`\`\`yaml
- name: Draft Content
  uses: ./actions/draft-content
  with:
    topic: "Write an introduction for a blog post about AI."
\`\`\`

## License

This action is licensed under the MIT License.
EOL

  cat <<'EOL' > "$REPO_NAME/actions/draft-content/scripts/draft.sh"
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
EOL
  chmod +x "$REPO_NAME/actions/draft-content/scripts/draft.sh"

  cat <<EOL > "$REPO_NAME/actions/draft-content/tests/test-draft.sh"
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
EOL
  chmod +x "$REPO_NAME/actions/draft-content/tests/test-draft.sh"
}

# Function to create scripts
create_scripts() {
  # setup.sh
  cat <<EOL > "$REPO_NAME/scripts/setup.sh"
#!/bin/bash

# Setup script for openai-actions

echo "Setting up the openai-actions repository..."

# Install dependencies, if any

echo "Setup complete."
EOL
  chmod +x "$REPO_NAME/scripts/setup.sh"

  # deploy.sh
  cat <<EOL > "$REPO_NAME/scripts/deploy.sh"
#!/bin/bash

# Deploy script for openai-actions

echo "Deploying the openai-actions repository..."

# Add deployment steps here

echo "Deployment complete."
EOL
  chmod +x "$REPO_NAME/scripts/deploy.sh"

  # utility.py
  cat <<EOL > "$REPO_NAME/scripts/utility.py"
#!/usr/bin/env python3

def main():
    print("Utility script for openai-actions.")

if __name__ == "__main__":
    main()
EOL
  chmod +x "$REPO_NAME/scripts/utility.py"
}

# Function to create documentation
create_docs() {
  # usage.md
  cat <<EOL > "$REPO_NAME/docs/usage.md"
# Usage

Detailed instructions on how to use the GitHub Actions in this repository.

## Generate Code Action

Description and usage examples.

## Draft Content Action

Description and usage examples.

# Add more sections as needed.
EOL

  # contributing.md
  cat <<EOL > "$REPO_NAME/docs/contributing.md"
# Contributing

Thank you for your interest in contributing to openai-actions!

## How to Contribute

1. Fork the repository.
2. Create a new branch: \`git checkout -b feature-name\`.
3. Make your changes.
4. Commit your changes: \`git commit -m 'Add feature'\`.
5. Push to the branch: \`git push origin feature-name\`.
6. Open a pull request.

## Code of Conduct

Please follow our [Code of Conduct](CODE_OF_CONDUCT.md).
EOL

  # faq.md
  cat <<EOL > "$REPO_NAME/docs/faq.md"
# FAQ

**Q:** How do I use these actions in my workflow?

**A:** Refer to the [Usage](./usage.md) documentation for detailed instructions.

**Q:** How do I contribute a new action?

**A:** Please see [Contributing](../CONTRIBUTING.md) for guidelines.

# Add more FAQs as needed.
EOL
}

# Function to create test scripts
create_tests() {
  # Integration Tests
  cat <<EOL > "$REPO_NAME/tests/integration/integration-test.sh"
#!/bin/bash

# Integration tests for openai-actions

echo "Running integration tests..."

# Example integration test

echo "Integration tests completed."
EOL
  chmod +x "$REPO_NAME/tests/integration/integration-test.sh"

  # Unit Tests
  cat <<EOL > "$REPO_NAME/tests/unit/unit-test.sh"
#!/bin/bash

# Unit tests for openai-actions

echo "Running unit tests..."

# Example unit test

echo "Unit tests completed."
EOL
  chmod +x "$REPO_NAME/tests/unit/unit-test.sh"
}

# Function to initialize actions
initialize_actions() {
  create_actions
}

# Function to display completion message
completion_message() {
  echo "Repository structure for '$REPO_NAME' has been initialized successfully."
  echo "Next steps:"
  echo "1. Navigate to the repository: cd $REPO_NAME"
  echo "2. Replace placeholder texts (e.g., YOUR_API_KEY) in scripts."
  echo "3. Initialize a git repository and make your first commit."
  echo "   - git init"
  echo "   - git add ."
  echo "   - git commit -m 'Initial commit'"
}
  
# Main Execution
create_dirs
create_root_files
create_github_workflows
create_examples
initialize_actions
create_scripts
create_docs
create_tests
completion_message

