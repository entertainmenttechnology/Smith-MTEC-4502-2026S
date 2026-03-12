# GitHub Actions Workflows

## Accessibility Scanner

The `accessibility-scan.yml` workflow automatically scans all course materials for accessibility issues using the [GitHub Accessibility Scanner](https://github.com/github/accessibility-scanner).

### What it does:

- **Automatically discovers** all markdown files in the repository (no manual URL list needed!)
- Scans all markdown files as rendered on GitHub.com
- Checks for WCAG 2 AA compliance issues
- Creates GitHub issues for accessibility findings
- Assigns issues to GitHub Copilot for AI-powered fix suggestions (if enabled)

### Dynamic file discovery:

The workflow automatically finds and scans:
- ✅ New markdown files you add
- ✅ Renamed/moved files
- ✅ Files in any subdirectory
- ❌ Files in `.git` directory (excluded)

**You never need to update the URL list manually!**

### When it runs:

- On every push to `main` branch
- On every pull request to `main` branch
- Manually via "Actions" tab → "Accessibility Scanner" → "Run workflow"

### Setup required:

1. **Create a Personal Access Token (PAT)**:
   - Go to https://github.com/settings/tokens?type=beta
   - Click "Generate new token" → "Generate new token (fine-grained)"
   - Set token name: `MTEC4502-Accessibility-Scanner`
   - Set expiration: 90 days (or custom)
   - Repository access: Select "Only select repositories" → Choose `Smith-MTEC-4502-2026S`
   - Permissions (under "Repository permissions"):
     - Actions: Read and write
     - Contents: Read and write
     - Issues: Read and write
     - Pull requests: Read and write
     - Metadata: Read-only (automatic)
   - Click "Generate token" and copy it

2. **Add the token as a repository secret**:
   - Go to repository Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `GH_TOKEN`
   - Value: Paste the token from step 1
   - Click "Add secret"

3. **Enable GitHub Actions** (if not already enabled):
   - Go to repository Settings → Actions → General
   - Under "Actions permissions", select "Allow all actions and reusable workflows"
   - Click "Save"

4. **Enable GitHub Issues** (if not already enabled):
   - Go to repository Settings → Features
   - Check the box for "Issues"

### Optional: Authenticate the scanner (recommended)

When the scanner runs without authentication it sees GitHub's own "unauthenticated" UI.
This includes a notice banner that contains a **"Signing in"** link (`<a href="/login">Signing in</a>`).
That link triggers a false-positive `link-in-text-block` axe violation (WCAG 1.4.1) because:

- The link colour (`#0366d6`) has only **1.29:1 contrast** against the surrounding grey text (`#7b7c7d`) — the required minimum is 3:1.
- GitHub does not apply an underline to the link, so there is no non-colour visual distinction.
- The element lives in **GitHub's own platform UI** and cannot be fixed by editing repository content.

**To eliminate these false positives**, provide GitHub credentials so the scanner browses pages as an authenticated user:

1. Create a **dedicated GitHub account** (or use an existing bot/service account) whose only purpose is accessibility scanning.
2. Add two repository secrets:
   - **`GITHUB_SCAN_USERNAME`** — the GitHub username of the scan account
   - **`GITHUB_SCAN_PASSWORD`** — the password of the scan account
3. The workflow already references these secrets via `username` / `password` / `login_url` parameters; no further changes are needed.

When these secrets are set the scanner logs in before scanning, so GitHub never renders the login notice banner, and the false-positive `link-in-text-block` violation will not appear.

> **Security note:** Use a purpose-built scanning account rather than a personal account. The account only needs read access to public repositories.

### Optional: Disable Copilot assignment

If you don't have GitHub Copilot or prefer to handle issues manually, edit the workflow file and change:

```yaml
skip_copilot_assignment: true
```

### How to run:

The workflow runs automatically on push/PR, or you can trigger it manually:

1. Go to the "Actions" tab in your repository
2. Click "Accessibility Scanner" in the left sidebar
3. Click "Run workflow" button
4. Select the branch
5. Click "Run workflow"

### Viewing results:

- Check the "Issues" tab for accessibility findings
- Each issue will contain:
  - Description of the accessibility problem
  - Location (URL and HTML element)
  - Suggested fix
  - Link to WCAG documentation
  - (Optional) Pull request from Copilot with proposed solution

### Notes:

- The scanner uses axe-core, which detects ~30-40% of accessibility issues
- Manual testing is still recommended for comprehensive accessibility evaluation
- Results are cached to avoid duplicate issue creation
