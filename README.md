# Workspace Repo

This repository was initialized for use in the Cursor workspace.

## Dev + Prod faux deployments

This repo includes two GitHub Actions workflows that create **dev** and **prod** environments and run a fake “deployment” (just `echo` output).

- **Dev**: runs on pushes to `main` and can be triggered manually
- **Prod**: manual-only (workflow dispatch)

### Run them

- **Dev**: GitHub → **Actions** → **Deploy (dev)** → **Run workflow**
- **Prod**: GitHub → **Actions** → **Deploy (prod)** → **Run workflow** (provide `version` like `main`, a tag, or a SHA)

