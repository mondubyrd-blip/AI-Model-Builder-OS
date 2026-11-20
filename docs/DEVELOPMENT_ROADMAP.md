# Hybrid Workspace Development Roadmap

This roadmap tracks proposed work. An item is complete only after implementation and verification evidence exists.

| Phase | Deliverable | Verification |
|---|---|---|
| 0 | API contracts and threat model | Schema validation and security review |
| 1 | React/TypeScript PWA shell | Browser tests; installability; offline shell test |
| 2 | Rust local agent | Loopback binding, pairing, workspace boundary tests |
| 3 | Python/Node/Rust execution adapters | Build/run/cancel tests and bounded output |
| 4 | Git and preview integration | Diff review, local commit, preview isolation tests |
| 5 | AI coding adapters | Reviewable patches, provider opt-in, local endpoint test |
| 6 | Buildroot appliance integration | Reproducible build and hardware/resource validation |

## Initial milestone: Phase 0

- [ ] Define versioned API schemas.
- [ ] Define capability-report schema.
- [ ] Define task lifecycle and error model.
- [ ] Define pairing and session-revocation flow.
- [ ] Define workspace path and symlink policy.
- [ ] Define audit event schema.
- [ ] Review threat model before implementing process execution.

## Non-goals

- Requiring VS Code or VSCodium.
- Requiring a cloud account or remote execution.
- Automatically downloading compilers or model weights.
- Automatically running scripts found in a repository.
- Replacing or rewriting the existing Buildroot appliance scaffold.
