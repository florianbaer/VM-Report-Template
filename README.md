# MSE Report Template

[![Build PDF File](https://github.com/florianbaer/VM-Report-Template/actions/workflows/build.yml/badge.svg)](https://github.com/florianbaer/VM-Report-Template/actions/workflows/build.yml)

This template is a base for the report while working for a master work or thesis.

Important: This report template is sufficient to meet the formatting and submission requirements of Master of Science in Engineering (MSE) programmes in Switzerland. Use it as a starting point for your MSE thesis or project report and adapt the content (title page, affiliation, supervisors, and any specific university requirements) as needed.

## Development Environment

### Using VS Code Dev Containers

This project includes a VS Code devcontainer configuration with a complete LaTeX environment and SSH agent forwarding support.

#### Prerequisites

- [VS Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

#### Getting Started

1. Clone this repository
2. Open the folder in VS Code
3. When prompted, click "Reopen in Container" or press `Ctrl+Shift+P` and run "Dev Containers: Reopen in Container"
4. Wait for the container to build (first time may take several minutes)

#### SSH Agent Forwarding

The devcontainer is configured to automatically forward your SSH agent for seamless Git operations:

**Automatic Configuration:**
- SSH agent forwarding is enabled by default
- Your `~/.ssh` directory is mounted into the container
- SSH keys are automatically available for Git operations

**Platform-Specific Setup:**

**Linux/macOS:**
- Ensure SSH agent is running: `ssh-agent`
- Add your SSH key: `ssh-add ~/.ssh/id_rsa` (or your key file)
- The devcontainer will automatically detect and use your SSH agent

**Windows:**
- Enable the OpenSSH Authentication Agent service in Windows Services
- Add your SSH key to the agent: `ssh-add`
- The devcontainer will mount your SSH directory and configure the agent

**WSL2 Users:**
- Ensure SSH agent is running in your WSL2 environment
- The devcontainer will automatically forward the agent socket

#### Troubleshooting SSH Agent

If SSH authentication isn't working in the container:

1. **Check SSH agent status:**
   ```bash
   echo $SSH_AUTH_SOCK
   ssh-add -l
   ```

2. **Restart the container:** Sometimes a container restart resolves agent forwarding issues

3. **Manual SSH key addition:** If automatic forwarding fails, you can manually add keys:
   ```bash
   ssh-add ~/.ssh/id_rsa
   ```

4. **Test Git SSH connection:**
   ```bash
   ssh -T git@github.com
   ```

#### Included LaTeX Environment

The container includes:
- Full TeX Live distribution
- Biber for bibliography processing
- Python3 with Pygments for syntax highlighting (minted package)
- All necessary LaTeX packages for this template

Note about VS Code LaTeX extensions: this template is designed to work seamlessly with popular VS Code LaTeX extensions (for example, LaTeX Workshop and common companion extensions). When you open this project in VS Code (inside the devcontainer), these extensions can automatically manage compilation, bibliography (Biber), forward/inverse search, and other tasks using the configured LaTeX toolchain.

#### Building the Document

Once in the container:

```bash
# Build the PDF
pdflatex -shell-escape main.tex
biber main
pdflatex -shell-escape main.tex
pdflatex -shell-escape main.tex
```

Or use the integrated LaTeX extension commands in VS Code — the extension will automatically run the correct sequence for you when configured.

## Quick Start

1. **Configure**: `python3 configure.py` or edit `config.tex`
2. **Build**: `make build`
3. **Watch**: `make watch` (auto-rebuild on changes)

## Key Commands

- `make configure` - Setup wizard
- `make build` - Build PDF with bibliography
- `make quick` - Fast build without bibliography
- `make clean` - Remove temporary files
- `make help` - Show all commands

### Manual Setup (Alternative)

If you prefer not to use the devcontainer: