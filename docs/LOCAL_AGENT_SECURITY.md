# Local Agent Security Boundary

Status: requirements baseline for the proposed hybrid development environment.

## Security objective

The local agent is a constrained bridge between a browser/PWA and the host operating system. The browser must not receive unrestricted operating-system authority.

## Required controls

1. Listen on loopback only. Do not bind to wildcard, LAN, or public interfaces.
2. Pair browser sessions through explicit local approval.
3. Use short-lived session credentials and provide immediate revocation.
4. Validate Origin and Host; reject unexpected origins.
5. Apply CSRF defenses to state-changing requests.
6. Run as the logged-in user, not root, by default.
7. Restrict file access to explicit workspace roots.
8. Canonicalize paths and reject traversal and symlink escapes.
9. Use structured task definitions and argument arrays. Do not pass browser-provided strings to a shell interpreter.
10. Require explicit confirmation for process execution, package installation, privileged actions, and network access.
11. Apply timeouts, output limits, resource limits where available, and cancellation.
12. Redact tokens, passwords, and environment secrets from output and logs.
13. Store audit records locally with timestamps, operation names, workspace identifiers, and outcomes.
14. Treat repository text, source comments, build logs, and model output as untrusted data.
15. Do not upload workspace contents, model weights, credentials, or logs unless the user explicitly configures and approves a remote operation.

## Threats to test

- Malicious website attempting to call localhost services.
- Cross-origin and DNS-rebinding attempts.
- Forged or replayed pairing credentials.
- Path traversal and symlink escape.
- Malicious repository scripts or project tasks.
- Output flooding and long-running child processes.
- Credential leakage through logs and environment variables.
- Browser tab compromise attempting unauthorized task execution.
- Agent crash leaving orphaned processes.

## Release gate

Do not expose the agent beyond loopback or ship it as an enabled appliance service until the threat model, test cases, authentication flow, and privilege boundaries have been reviewed and tested.
