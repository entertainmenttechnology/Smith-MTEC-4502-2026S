---
lang: en
---
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
