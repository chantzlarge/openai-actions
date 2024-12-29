# [@chantzlarge](https://github.com/chantzlarge/)/[openai-actions](https://github.com/chantzlarge/openai-actions/)

## TL;DR

- Composite GitHub Actions for automatically refining Issue and Pull Request descriptions
- Uses OpenAI’s GPT-4 to generate improved descriptions
- Requires GitHub token and OpenAI API key for authentication
- Includes two actions: **On Issues Opened** and **On Pull Request Opened**
- Easily extensible and customizable

## Getting Started

### Prerequisites

- **GitHub Token**: Required to interact with GitHub’s REST API
- **OpenAI API Key**: Required for invoking GPT-4 completions
- **jq & curl**: Required by the composite Actions to process JSON and make HTTP requests  
  > For local testing, make sure you have `jq` and `curl` installed on your development machine (e.g., `sudo apt-get install -y jq curl`).

### Installation

1. **Clone or fork** this repository in your own GitHub account.
2. **Review and set** the appropriate permissions for your GitHub token (typically `repo` permissions are sufficient).
3. **Configure** the input fields in the `action.yml` files (e.g., `github_token`, `openai_api_key`, `issue_template`, `pull_request_template`) based on your project’s needs.
4. **Include** these actions in your workflow by referencing their paths (e.g., `.github/actions/your-actions-folder`) or by copying them directly into your repository.

## Usage

### Running the Actions

1. **On Issues Opened**:  
   - Triggered automatically whenever an Issue is opened in your repository.  
   - Updates the Issue body with an improved, AI-generated description based on your issue template.
2. **On Pull Request Opened**:  
   - Triggered automatically whenever a Pull Request is opened in your repository.  
   - Updates the PR body with an improved, AI-generated description based on your pull request template.

Example workflow snippet:

```yaml
name: Refine Descriptions
on:
  issues:
    types: [opened]
  pull_request:
    types: [opened]

jobs:
  refine-issues-and-prs:
    runs-on: ubuntu-latest
    steps:
      - name: Use On Issues Opened Action
        if: ${{ github.event_name == 'issues' }}
        uses: ./.github/actions/on-issues-opened
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          openai_api_key: ${{ secrets.OPENAI_API_KEY }}
      
      - name: Use On Pull Request Opened Action
        if: ${{ github.event_name == 'pull_request' }}
        uses: ./.github/actions/on-pull-request-opened
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          openai_api_key: ${{ secrets.OPENAI_API_KEY }}
```

### Testing the Actions

- You can **open a dummy Issue** or **create a test Pull Request** in a non-production environment (e.g., a fork or test repository) to verify that the Action updates the descriptions as expected.
- Debug logs can be viewed in your GitHub Actions run (under your repository’s **Actions** tab).

## Contributing

- **Guidelines**: Please follow the standard GitHub Fork-and-Pull model. Fork the repository, make your changes, and open a Pull Request.
- **Coding Standards**: Use descriptive commit messages and ensure all scripts are properly formatted (e.g., shell scripts).
- **Development Methodologies**: We recommend small, incremental changes. For major changes, please open an Issue to discuss the proposal first.
- **Style Guides**: Adhere to conventional commits or a similarly consistent commit/PR structure.  

## Deployment

- **GitHub Actions Marketplace**: If you wish to distribute these Actions to a broader audience, publish them to the GitHub Actions Marketplace.
- **Production vs. Staging**: Consider using separate branches (e.g., `main` for production, `dev` for staging). Update your `action.yml` in each branch to point to the correct versions.

## Built-with

- **GitHub Actions** (Composite Actions)
- **OpenAI GPT-4** for generating improved content
- **jq** for JSON parsing
- **curl** for HTTP requests
- **Bash** scripting for automation

## Author(s)

- [Chantz Large](https://github.com/chantzlarge)

## Versioning

This project uses [Semantic Versioning 2.0.0](https://semver.org/).

## License

Distributed under the [MIT License](./LICENSE).  

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)
