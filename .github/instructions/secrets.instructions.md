---
applyTo: "**/*secret*.yaml,**/*secret*.yml,**/*sealed*.yaml,**/*sealed*.yml,**/values.yaml,**/devsecrets.yaml"
description: "Credential safety and SealedSecret handoff rules"
---

# Secret Handling

- Never request, inspect, copy, log, or invent real credentials.
- Agents may add or update `SealedSecret` structure, placeholder values, secret references, and human handoff notes.
- Treat plaintext `kind: Secret` resources as intentional exceptions that require human review. Do not convert a placeholder into a real value.
- When a change requires a secret, leave a clear placeholder or documented handoff and report that sealing remains outstanding.
