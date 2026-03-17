# Dotfiles

Personal configuration files for macOS.

## What's included

| File | Description |
|------|-------------|
| `.zprofile` | Zsh login shell — brew + nvm environment (loaded by all shells, including VSCode) |
| `.zshrc` | Zsh interactive shell — completions, history, starship prompt |
| `.bash_profile` | Bash config (fallback) — same essentials + git completion |
| `.gitconfig` | Git aliases, merge/push/pull settings, LFS |
| `starship.toml` | Starship prompt theme — git branch/status, language versions, colors |
| `mcp.json` | VSCode GitHub Copilot MCP servers configuration |
| `.claude/settings.json` | Claude Code global permissions (symlinked to `~/.claude/settings.json`) |
| `.claude/mcp-servers.json` | Claude Code MCP servers (merged into `~/.claude.json`) |
| `.secrets.example` | Template for API keys (actual keys in `~/.secrets`) |
| `install.sh` | Symlinks all dotfiles to `~/` in one command |

## Fresh install on macOS

### 1. Set your default shell to zsh

Open **Terminal > Settings > General** and set "Shells open with" to **Default login shell** (which is `/bin/zsh` on macOS).

### 2. Install prerequisites

```sh
# Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Starship prompt
brew install starship
```

### 3. Clone this repo

```sh
git clone https://github.com/dlepaux/dotfiles.git ~/dotfiles
```

### 4. Install (symlink all config files)

```sh
./install.sh
```

This creates symlinks from `~/` to this repo, so edits are automatically tracked by git.

### 5. Activate

Open a new terminal tab, or run:

```sh
source ~/.zshrc
```

You should see a colorful prompt with your username, hostname, current directory, and git branch/status when inside a repo.

## MCP Servers (mcp.json)

Configuration for [Model Context Protocol](https://modelcontextprotocol.io/) servers used by GitHub Copilot in VSCode.

| Server | Description |
|--------|-------------|
| `sequentialthinking` | Runs via Docker — enables structured, step-by-step reasoning |
| `context7` | Up-to-date documentation lookup for libraries and frameworks |
| `chrome-devtools-mcp` | Interact with Chrome DevTools (inspect, debug, network) |
| `firecrawl-mcp` | Web scraping and crawling via the Firecrawl API |

### Setup

Copy to your VSCode user settings directory:

```sh
cp ~/path/to/dotfiles/mcp.json ~/.vscode/mcp.json
```

**Required API keys** — VSCode will prompt for these on first use:
- `FIRECRAWL_API_KEY` — get one at [firecrawl.dev](https://firecrawl.dev)

**Required dependencies:**
- Docker (for `sequentialthinking`)
- Node.js / npx (for `context7`, `chrome-devtools-mcp`, `firecrawl-mcp`)

## Claude Code

Configuration for [Claude Code](https://claude.ai/claude-code) (Anthropic's CLI/VSCode extension).

### Settings (`.claude/settings.json`)

Global permissions for Claude Code — allows common dev tools (git, npm, docker, etc.) without per-command prompts. Symlinked to `~/.claude/settings.json` by `install.sh`.

### MCP Servers (`.claude/mcp-servers.json`)

Same MCP servers as VSCode, configured for Claude Code's format. Merged into `~/.claude.json` by `install.sh` using `jq`.

| Server | Description |
|--------|-------------|
| `sequentialthinking` | Structured step-by-step reasoning (Docker) |
| `context7` | Library/framework documentation lookup |
| `chrome-devtools` | Chrome DevTools interaction |
| `firecrawl-mcp` | Web scraping via Firecrawl API |
| `figma` | Figma design context (HTTP) |
| `github` | GitHub repos, issues, PRs, code search (Docker) |
| `playwright` | Browser automation and E2E testing |
| `docker` | Container management, logs, inspect |

### API Keys

API keys are stored in `~/.secrets` (chmod 600, never committed). On first install, `install.sh` creates it from `.secrets.example`.

```sh
# Edit with your actual keys
vim ~/.secrets
```

### Discover more MCP servers

Browse the official registry: [github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
