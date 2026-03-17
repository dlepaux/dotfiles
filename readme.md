# Dotfiles

Personal configuration files for macOS.

## What's included

| File | Description |
|------|-------------|
| `.zprofile` | Zsh login shell — brew + nvm environment (loaded by all shells, including VSCode) |
| `.zshrc` | Zsh interactive shell — completions, history, starship prompt, aliases |
| `.bash_profile` | Bash config (fallback) — same essentials + git completion |
| `.gitconfig` | Git aliases, merge/push/pull settings, LFS |
| `starship.toml` | Starship prompt theme — git branch/status, language versions, colors |
| `mcp.json` | VSCode MCP servers configuration |
| `.claude/` | Claude Code configuration (settings, skills, agents, hooks) |
| `.secrets.example` | Template for API keys (actual keys in `~/.secrets`) |
| `.gitignore` | Prevents accidental commit of secrets and editor files |
| `install.sh` | Symlinks everything + merges MCP config |

## Fresh install on macOS

### 1. Install prerequisites

```sh
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Required tools
brew install starship jq
```

### 2. Clone and install

```sh
git clone https://github.com/dlepaux/dotfiles.git ~/WebServer/dlepaux/dotfiles
cd ~/WebServer/dlepaux/dotfiles
./install.sh
```

### 3. Configure secrets

```sh
vim ~/.secrets  # Fill in your API keys
```

### 4. Activate

Open a new terminal tab, or `source ~/.zshrc`.

## Claude Code

Configuration for [Claude Code](https://claude.ai/claude-code) (Anthropic's CLI/VSCode extension).

### Personal preferences (`.claude/CLAUDE.md`)

Loaded in every session. Defines coding principles (KISS > DRY > SOLID), commit style (conventional commits), mentor mindset, and quality expectations.

### Skills (slash commands)

| Skill | Description |
|-------|-------------|
| `/review` | Code review — quick or deep depending on change size |
| `/fix-issue <#>` | Read GitHub issue, branch, implement, test, commit |
| `/test` | Auto-detect project type and run the right test suite |
| `/post-feature` | Post-implementation quality gate (format, lint, types, tests, review) |
| `/deploy-check` | Pre-deployment checklist with pass/fail report |

### Agents

| Agent | Model | Description |
|-------|-------|-------------|
| `reviewer` | Sonnet | Quick code review on git diff |
| `deep-reviewer` | Opus | In-depth architecture, security, performance review |
| `debugger` | Opus | Root cause analysis with fix implementation |

### Hooks

| Event | Hook | Description |
|-------|------|-------------|
| `PostToolUse` | `format.sh` | Auto-format files after Edit/Write (per-language) |
| `PreToolUse` | `protect-env.sh` | Block access to `.env` files |
| `Notification` | macOS alert | Desktop notification when Claude needs attention |

### MCP Servers (`.claude/mcp-servers.json`)

Merged into `~/.claude.json` by `install.sh` (preserves manually added servers).

| Server | Description |
|--------|-------------|
| `sequentialthinking` | Structured reasoning (Docker) |
| `context7` | Library/framework documentation lookup |
| `chrome-devtools` | Chrome DevTools interaction |
| `firecrawl-mcp` | Web scraping via Firecrawl API |
| `figma` | Figma design context (HTTP) |
| `github` | GitHub repos, issues, PRs (Docker) |
| `playwright` | Browser automation and E2E testing |
| `docker` | Container management, logs, inspect |

### API Keys

Stored in `~/.secrets` (chmod 600, never committed). Required keys:

| Variable | Service |
|----------|---------|
| `FIRECRAWL_API_KEY` | [firecrawl.dev](https://firecrawl.dev) |
| `CONTEXT7_API_KEY` | [context7.com](https://context7.com) |
| `GITHUB_TOKEN` | [GitHub PAT](https://github.com/settings/tokens) (fine-grained) |

#### GitHub PAT scopes (fine-grained token)

| Permission | Access | Why |
|-----------|--------|-----|
| Contents | Read & Write | Read/search code, create files |
| Issues | Read & Write | Create/manage issues |
| Pull requests | Read & Write | Create/review PRs |
| Metadata | Read-only | Basic repo info (auto-granted) |
| Actions | Read-only | View workflow runs/logs (optional) |
| Workflows | Read & Write | Trigger/manage CI (optional) |

### Discover more MCP servers

Browse the official registry: [github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)

## VSCode MCP Servers (mcp.json)

Same core servers as Claude Code, adapted for VSCode's format. Symlinked to `~/.vscode/mcp.json` by `install.sh`.

**Required dependencies:**
- Docker (for `sequentialthinking`)
- Node.js / npx (for `context7`, `chrome-devtools`, `firecrawl-mcp`, `playwright`, `docker`)
