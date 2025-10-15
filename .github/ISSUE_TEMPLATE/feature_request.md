---
name: Feature Request
about: Suggest a new feature or enhancement
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

## Feature Description

<!-- A clear and concise description of the feature you'd like to see -->

## Use Case

<!-- Describe the problem this feature would solve -->

## Proposed Solution

<!-- How you envision this feature working -->

## Target Role(s)

<!-- Which role(s) would this affect? -->
- [ ] New role (specify name):
- [ ] Existing role (specify):
- [ ] Multiple roles
- [ ] Core playbook

## Platform Support

<!-- Which platforms should support this feature? -->
- [ ] macOS
- [ ] Ubuntu
- [ ] Both

## Implementation Ideas

<!-- Technical implementation details, if you have any -->

### Configuration Variables

```yaml
# Example of new variables in group_vars/all.yml
feature_enabled: true
feature_option: "value"
```

### Tasks Structure

```yaml
# Pseudo-code or example tasks
- name: Example task
  package:
    name: example
    state: present
```

## Alternatives Considered

<!-- Other approaches you've thought about -->

## Additional Context

<!-- Any other context, screenshots, or examples -->

## Benefits

<!-- How this would improve the playbook -->

-
-

## Breaking Changes

<!-- Would this introduce breaking changes? -->
- [ ] Yes (describe):
- [ ] No

## Related Issues

<!-- Link to related issues if any -->

## Checklist

- [ ] This feature aligns with the project goals
- [ ] I've searched for similar feature requests
- [ ] I'm willing to contribute to implementation
- [ ] I've considered backward compatibility
