# On Issue Opened GitHub Action

TBD

## Features

TBD

## Inputs

| Input Name       | Description                                      | Required |
|-------------------|--------------------------------------------------|----------|
| `openai_api_key`  | Your OpenAI API key                             | Yes      |
| `github_token`    | GitHub token with permission to update the PR   | Yes      |
| `issue_template`    | TBD   | No      |

## Outputs

TBD

## Example Workflow

Add this workflow to your repository under `.github/workflows/on_issue_opened.yml`:

```yaml
name: On Issue Opened
on:
  pull_request:
    types: [opened]

jobs:
  refine_and_update:
    runs-on: ubuntu-latest
    steps:
      - name: Use On Issue Opened Action
        uses: ./on-issue-opened
        with:
          openai_api_key: ${{ secrets.OPENAI_API_KEY }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
          issue_template: ./github/ISSUE_TEMPLATE/issue_template.md
```

## Repository Structure

```plaintext
.
├── README.md           # Documentation for the action
├── action.yml          # Metadata defining the GitHub Action
└── handler.py          # Python script to process and refine the PR description
```

## How It Works

1. **Fetch Metadata**:
   - The action fetches the base and head branches of the pull request to compute the git diff.
   - Pull request metadata (e.g., title, labels, reviewers) is extracted.

2. **Custom PR Template**:
   - If a `.github/pull_request_template.md` file exists, it is used as the base for the refined PR description.

3. **OpenAI Refinement**:
   - The action sends the PR data and diff to OpenAI's API for refinement.
   - The resulting description is clear, comprehensive, and professional.

4. **Update PR Description**:
   - The refined description is updated on the pull request using the GitHub API.

## Dependencies

- **Python 3.10 or higher**:
  Used to process the pull request metadata and interact with OpenAI's API.
- **OpenAI Python Library**:
  Required for communication with OpenAI's API.
- **jq Command-Line Tool**:
  Used to process JSON data in shell scripts.

## Development and Testing

### Run Locally

You can test the action locally by simulating the environment and passing a pull request payload. For example:

```bash
echo '{"pull_request": {...}}' | python3 handler.py
```

Replace `{...}` with the JSON payload of a pull request event.

### Debugging

- Check the `DIFF_CONTENT` and `OPENAI_API_KEY` environment variables during runtime.
- Ensure `.github/pull_request_template.md` exists if a custom template is desired.

---

With this GitHub Action, your pull request descriptions will be more detailed, informative, and ready for review. For any issues or feature requests, feel free to open an issue in the repository.
