# Draft Content Action

This GitHub Action integrates with the OpenAI API to draft content based on a given topic.

## Inputs

- **topic** (required): The topic to draft content about.

## Outputs

- **drafted_content**: The content drafted by OpenAI.

## Usage

```yaml
- name: Draft Content
  uses: ./actions/draft-content
  with:
    topic: "Write an introduction for a blog post about AI."
```

## License

This action is licensed under the MIT License.
