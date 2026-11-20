# AI Model Builder OS — Hybrid Development Architecture

Status: proposed architecture baseline  
Scope: additive to the existing Buildroot appliance scaffold  
Preservation: this document does not alter the original v0.1 archive, existing hardware profiles, or Buildroot files.

## 1. Objective

Provide one development workspace that can be used through a browser, an installable Progressive Web App (PWA), and a native/local mode where the same web interface communicates with a local execution agent.

The web interface is the primary user experience. Local execution is supplied by a separately managed native service. VS Code and VSCodium are optional external clients, not required components.

## 2. Logical architecture

```text
                 AI Model Builder OS
              Unified Development Workspace
                           |
          +----------------+----------------+
          |                |                |
      Browser UI        Installed PWA    Optional IDE
          |                |                |
          +----------------+----------------+
                           |
                 Authenticated Local Bridge
                      HTTP / WebSocket
                           |
                    Rust Local Agent
                           |
       +-------------------+-------------------+
       |           |           |               |
    Workspace   Task/CLI    Build/Run      Hardware Probe
    Filesystem   Sessions   Toolchains     CPU/GPU/NPU
       |           |           |               |
       +-----------+-----------+---------------+
                           |
                  Local Project Storage

      Optional remote worker (disabled by default)
      connects only through explicit user configuration.
```

## 3. Components

### 3.1 Web workspace
- React + TypeScript application.
- Monaco Editor or CodeMirror behind an editor abstraction.
- Project explorer, multi-file editing, search, diff, and preview.
- Task/output panels and accessible terminal view.
- PWA manifest and service worker for installation and offline shell assets.
- IndexedDB for UI preferences, drafts, and transient offline state; project source of truth remains the configured workspace filesystem when a local agent is connected.

### 3.2 Rust local agent
- Runs as a user-level service; no root privileges by default.
- Exposes a loopback-only API.
- Owns filesystem, process, build, and runtime operations.
- Uses explicit workspace roots and path canonicalization.
- Executes allowlisted tools with structured arguments; never evaluates arbitrary shell text merely because it came from the browser.
- Supports cancellation, timeouts, output limits, and process cleanup.
- Reports capabilities and toolchain availability without assuming hardware acceleration support.

### 3.3 Local bridge and trust model
- Bind to loopback only; never expose the agent to the LAN by default.
- Pairing uses a one-time local approval flow and short-lived session credentials.
- Validate Origin and Host; use CSRF protections where applicable.
- Require user approval for workspace access, process launch, package installation, privileged operations, and network access.
- Do not put long-lived secrets in browser storage.
- Keep an auditable local action log with timestamps, requested operation, target workspace, and result.
- Do not transmit source files, model weights, credentials, or logs to a remote service by default.

### 3.4 Execution adapters
Adapters provide a consistent interface for Python, JavaScript/TypeScript, Rust, and optional languages. Each adapter declares availability, version, supported operations, and resource limits. Toolchains are installed separately and are not silently downloaded.

### 3.5 Build and preview
- Build jobs execute locally through adapters.
- Build outputs are stored in a project-scoped artifact directory.
- Preview servers bind to loopback and use temporary session URLs.
- Logs and exit codes are retained per task.
- Build recipes are reproducible where upstream toolchains permit.

### 3.6 Git integration
- Local Git remains the source of truth for repository operations.
- Show diffs and staged changes before commits.
- Remote synchronization is optional and explicit.
- Credentials are delegated to system Git credential helpers; never store tokens in project files.

### 3.7 AI coding integration
- Provider-neutral adapter interface.
- Local model endpoints are supported when configured and available.
- Remote providers are optional and disabled until configured by the owner.
- AI-generated patches are reviewable diffs; applying changes is a separate operation.
- Treat repository content, tool output, and model output as untrusted data, not executable instructions.

## 4. Operating modes

| Mode | Interface | Execution | Offline behavior |
|---|---|---|---|
| Browser-only | Browser UI | Optional configured worker | Cached interface; no local filesystem or terminal access by default |
| Installed PWA | PWA | Same as browser unless paired | Cached shell and saved drafts |
| Local hybrid | PWA/browser UI | Rust agent on same device | Core editing, Git, builds, and local tools available subject to installed dependencies |
| Remote worker (optional) | Same UI | Explicitly configured remote worker | Requires network; never the default |

A PWA cannot independently provide unrestricted terminal, filesystem, USB, or hardware access. Those operations require the native agent or a separately authorized execution worker.

## 5. Suggested repository layout

```text
apps/
  web/                    # React/TypeScript PWA
  desktop-shell/          # optional native packaging; later phase
services/
  local-agent/            # Rust local execution service
  adapters/
    python/
    node/
    rust/
packages/
  api-contracts/          # shared request/response schemas
  ui/                     # reusable interface components
  editor/                 # editor abstraction
```

This is a proposed layout. Existing root-level Buildroot and appliance directories remain unchanged.

## 6. API boundary (initial contract)

Initial API groups:
- `GET /v1/health` — agent health and protocol version.
- `GET /v1/capabilities` — installed adapters and detected capabilities.
- `POST /v1/workspaces/open` — request a user-approved workspace root.
- `GET /v1/workspaces/{id}/tree` — list permitted project entries.
- `GET /v1/files/{id}` and `PUT /v1/files/{id}` — read/write approved files.
- `POST /v1/tasks` — launch a declared task through an adapter.
- `GET /v1/tasks/{id}` — task state and bounded output.
- `POST /v1/tasks/{id}/cancel` — cancel a task.
- WebSocket task stream — incremental output and status.

The API must use versioned schemas, strict input validation, request size limits, and explicit error types. File IDs are opaque server-issued handles; clients must not be able to escape approved workspace roots with path traversal or symlinks.

## 7. Security and operational requirements

- Loopback-only listener; random local port.
- Pairing approval and short-lived credentials.
- Least privilege; no root daemon.
- Workspace allowlist and symlink-safe path handling.
- No arbitrary browser-to-shell passthrough.
- Per-task timeout, output cap, and cancellation.
- Explicit network permission for build tasks that need downloads.
- No automatic installation or execution of repository scripts.
- Redact credentials from logs.
- Local audit trail and clear revocation control.
- Dependency and license inventory for shipped components.
- Threat-model review before exposing any remote worker mode.

## 8. Relationship to the existing OS appliance

This development environment is an application layer that may run on the eventual AI Model Builder OS image. It can also be developed and tested on a conventional Linux host first.

It does not replace Buildroot as the current appliance build-system baseline, BLUEBIRD as the documented primary hardware port target, the read-only capability discovery scripts, or existing archive provenance and SHA-256 records.

The browser application may run elsewhere, but the local agent must report actual host capabilities. A web interface does not make an unsupported NPU, GPU, compiler, or driver usable.

## 9. Acceptance criteria

1. PWA loads and installs on a supported browser.
2. Browser-only mode never claims local terminal or filesystem access when no agent is paired.
3. Local agent binds only to loopback and requires pairing approval.
4. A user-approved workspace can be browsed and edited.
5. Python, Node.js, and Rust adapters report installed versions accurately.
6. A sample project can be built and run locally with bounded logs and cancellation.
7. Git status and diffs are visible; remote push is explicit.
8. Offline shell assets and saved drafts work without a network connection.
9. No source, credential, or model file is transmitted remotely by default.
10. Existing Buildroot validation remains independent and passes without changes from this architecture addition.

## 10. Implementation sequence

Phase 0 — contracts and threat model  
Define API schemas, capability report, task lifecycle, trust boundaries, and audit events.

Phase 1 — PWA shell  
Create the React/TypeScript workspace shell, manifest, service worker, editor, and project navigation using mock data only.

Phase 2 — Rust local agent  
Implement loopback health/capabilities endpoints, pairing, workspace allowlist, and safe file operations.

Phase 3 — task execution  
Add structured Python/Node/Rust adapters, task lifecycle, cancellation, output limits, and terminal presentation.

Phase 4 — Git and previews  
Add local Git status/diff/commit workflows and loopback preview servers.

Phase 5 — AI integration  
Add provider-neutral coding adapters, local model integration, reviewable patches, and explicit remote provider settings.

Phase 6 — appliance integration  
Package the web workspace and local agent as Buildroot packages only after host-mode validation and resource measurement.

No implementation phase is considered complete merely because this architecture document exists.
