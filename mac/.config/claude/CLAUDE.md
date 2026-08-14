# Environment
- MacBook Air (macOS). This is the only machine you run on.
- There is one remote Kubernetes node — `kubectl` works fine against it from here, but its host-level config (e.g. Cloudflare setup) lives on that separate host, not this machine.
- All infra repos live under `~/repos/gitea/purplebyte24/`, hosted on self-hosted Gitea.

# CLI aliases (real shell aliases, usable directly)
- `k` = kubectl
- `f` = fd (use instead of find — faster)
- `g` = rg (use instead of grep — faster)

# Infra / GitOps
- **k8s-infra**: all cluster manifests + bootstrap scripts. ArgoCD pulls from this repo — it's the source of truth for the cluster.
- **kvm-infra**: creates/destroys ephemeral KVMs used as Gitea Actions runners (instead of Docker-in-Docker).
- **prebaked-gitea-runner**: Dockerfile for the custom gitea-runner image (OpenSSH + Node.js preinstalled).
- **cicd-common**: shared/reusable CI pipeline steps.
- **gitea-backup-tools**: image for backing up the Gitea instance (minor, low-importance repo).
- Manifest style: Helm for third-party apps; plain YAML + Kustomize overlays for own resources.
- Secrets: SOPS (encrypted in git) for most secrets; a few bootstrap secrets live in Bitwarden instead.
- Namespaces: `infra` namespace for infra components, one namespace per app otherwise.

# Never do this
- Don't `kubectl edit`/`apply` ArgoCD-managed resources directly — ArgoCD will just revert/recreate them. Change the source in k8s-infra instead.
- `kubectl delete` on stale ArgoCD-managed resources is OK, but always ask first.
- Always ask before any destructive command: kubectl delete, force-push, git reset --hard, rm -rf, etc. — no exceptions based on perceived low risk.
- Don't go looking for the Kubernetes node's Cloudflare config from this machine — wrong host.

# Working style
- Be terse: act, then report back briefly. Don't narrate reasoning before acting unless asked.
- For infra changes, maintain a PROGRESS.md/RUNBOOK.md-style file in whichever repo the change lives in.
