# handle_pull_request_opened.py

import json
import subprocess
import sys
import os
import openai

# Adjust these maximum lengths as needed based on typical PR sizes.
MAX_LENGTH_DRAFT = 3000
MAX_LENGTH_DIFF = 3000

def get_git_root():
    """
    Get the root directory of the current Git project.
    """
    try:
        git_root = subprocess.check_output(["git", "rev-parse", "--show-toplevel"], text=True).strip()
        return git_root
    except subprocess.CalledProcessError:
        raise RuntimeError("Not a git repository or unable to determine git root.")

def load_pr_template(template_path=".github/pull_request_template.md"):
    """
    Load the pull request template from the given file path, relative to the Git project root.
    If the file does not exist, return a default template.
    """
    try:
        git_root = get_git_root()
        full_path = os.path.join(git_root, template_path)
        if os.path.exists(full_path):
            with open(full_path, "r") as f:
                return f.read()
        else:
            print(f"Warning: Template file '{full_path}' not found. Using default template.", file=sys.stderr)
            return "TBD"
    except RuntimeError as e:
        print(f"Error determining Git root: {e}", file=sys.stderr)
        return "TBD"

def integrate_pr_data_into_template(template, pull_request):
    """
    Integrate data from the pull_request payload into the template.
    """
    title = pull_request.get('title', 'No title')
    user_login = pull_request.get('user', {}).get('login', 'Unknown user')
    html_url = pull_request.get('html_url', '')
    source_branch = pull_request.get('head', {}).get('ref', '')
    target_branch = pull_request.get('base', {}).get('ref', '')
    body = pull_request.get('body', 'No description provided')

    labels = pull_request.get('labels', [])
    label_names = ', '.join(label.get('name', '') for label in labels) if labels else 'None'

    assignees = pull_request.get('assignees', [])
    assignee_names = ', '.join(a.get('login', '') for a in assignees) if assignees else 'None'

    requested_reviewers = pull_request.get('requested_reviewers', [])
    reviewer_names = ', '.join(r.get('login', '') for r in requested_reviewers) if requested_reviewers else 'None'

    requested_teams = pull_request.get('requested_teams', [])
    team_names = ', '.join(t.get('slug', '') for t in requested_teams) if requested_teams else 'None'

    integrated = template.replace(
        "TBD",
        f"""
**Title:** {title}

**Opened by:** {user_login}

**Source Branch:** {source_branch}
**Target Branch:** {target_branch}

**PR Body:** {body}

**Labels:** {label_names}
**Assignees:** {assignee_names}
**Requested Reviewers:** {reviewer_names}
**Requested Teams:** {team_names}

**URL:** {html_url}
""",
        1
    )

    return integrated

def truncate_text(text, max_length=5000):
    """
    Truncate the text to ensure it doesn't exceed a given length.
    """
    if len(text) > max_length:
        return text[:max_length] + "\n[...truncated...]"
    return text

def refine_description_with_openai(draft):
    """
    Refine the pull request description using the OpenAI API and include the git diff.
    If the content is too large, truncate the diff or the draft as needed.
    """
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY environment variable not set.")

    diff_content = os.getenv("DIFF_CONTENT", "").strip()

    # Truncate both draft and diff to help ensure we don't exceed context length.
    draft = truncate_text(draft, max_length=MAX_LENGTH_DRAFT)
    diff_content = truncate_text(diff_content, max_length=MAX_LENGTH_DIFF)

    client = openai.Client(api_key=api_key)

    prompt_content = (
        "Please refine the following pull request description to be more clear, "
        "comprehensive, and follow best practices. Incorporate the provided PR details "
        "into each relevant section. For sections still marked as 'TBD', use the context "
        "from the PR details to produce meaningful content (e.g., benefits, impact, "
        "testing, etc.).\n\n"
        "IMPORTANT: The following lines are provided for context only and should NOT appear "
        "in the final description:\n"
        "- **Opened by:** <user>\n"
        "- **Source Branch:** <branch>\n"
        "- **Target Branch:** <branch>\n"
        "- **Labels:** <labels>\n"
        "- **Assignees:** <assignees>\n"
        "- **Requested Reviewers:** <reviewers>\n"
        "- **Requested Teams:** <teams>\n"
        "- **URL:** <url>\n\n"
        "Use these lines to better inform the PR summary, testing, and benefits, but do not "
        "reproduce them directly.\n\n"
        "Below is the current PR draft:\n\n"
        + draft
        + "\n\n### Git Diff for Context\n\n"
        + diff_content
    )

    # Additional truncation step to ensure prompt fits within model context
    # Since token counts differ from character counts roughly (1 token ~4 chars),
    # keep a safe margin. We can further reduce if needed.
    prompt_content = truncate_text(prompt_content, max_length=MAX_LENGTH_DRAFT + MAX_LENGTH_DIFF + 1000)

    messages = [
        {"role": "system", "content": "You are a helpful assistant that refines pull request descriptions."},
        {"role": "user", "content": prompt_content}
    ]

    # If still too large, consider a retry with more aggressive truncation
    # or pre-processing steps. For now, we'll assume this is sufficient.

    response = client.chat.completions.create(
        model="gpt-4",
        messages=messages,
        temperature=0.7,
        max_tokens=1000
    )

    refined_description = response.choices[0].message.content.strip()
    return refined_description

if __name__ == "__main__":
    payload = json.load(sys.stdin)
    pull_request = payload.get('pull_request', {})

    template = load_pr_template()
    draft = integrate_pr_data_into_template(template, pull_request)
    refined_description = refine_description_with_openai(draft)

    print(refined_description)
