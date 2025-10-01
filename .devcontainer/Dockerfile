# Use small TeXLive image and install additional packages as needed
FROM texlive/texlive:latest-small

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-client \
    git \
    pre-commit \
    sudo \
    curl \
    ca-certificates \
    python3 \
    python3-pip \
    make \
    chktex \
    aspell \
    aspell-en \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Ensure /bin/sh is available and points to bash for compatibility
# This is important for VS Code dev containers
RUN if [ -x /bin/bash ] && [ ! -e /bin/sh ]; then ln -sf /bin/bash /bin/sh; fi

# User will be created automatically by devcontainer features

# Configure Git defaults
RUN git config --global user.name "Dev Container User" \
    && git config --global init.defaultBranch main

# Ensure Pygments is available for minted syntax highlighting
# The minted package requires pygmentize executable to highlight code blocks
# System version is adequate, skip upgrade to avoid conflicts
RUN which pygmentize || pip3 install pygments --break-system-packages

# Add TeX Live binaries to PATH
ENV PATH="/usr/local/texlive/2025/bin/aarch64-linux:${PATH}"

# Install additional TeX Live packages needed for thesis template
RUN tlmgr update --self

# Install packages individually to handle failures gracefully
# Note: algpseudocode is part of algorithmicx, subcaption is in collection-latexextra
RUN tlmgr install pdfx biber latexmk latexindent xmpincl titlesec multirow microtype csquotes biblatex biblatex-apa minted fvextra fancyvrb glossaries glossaries-english algorithmicx algorithms tocloft xstring texcount caption hyperref; exit 0

# Essential collections to avoid missing individual packages
# RUN tlmgr install collection-latexextra || true          # Extra LaTeX packages (includes titlesec, etc.)

# Optional packages (uncomment lines below if needed):
# RUN tlmgr install collection-fontsrecommended || true    # Additional fonts
# RUN tlmgr install collection-fontutils || true           # Font utilities
# RUN tlmgr install collection-bibtexextra || true         # Additional bibliography styles
# RUN tlmgr install collection-mathscience || true         # Math and science packages
# RUN tlmgr install biblatex-apa || true                   # APA citation style
# RUN tlmgr install fvextra || true                        # Enhanced verbatim
# RUN tlmgr install xstring || true                        # String manipulation
# RUN tlmgr install algorithm2e || true                    # Alternative algorithm package
# RUN tlmgr install algorithmicx || true                   # Alternative algorithm package
# RUN tlmgr install booktabs || true                       # Professional table formatting

# SSH agent configuration will be handled by devcontainer postCreateCommand