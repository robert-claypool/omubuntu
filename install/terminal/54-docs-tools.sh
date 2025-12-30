#!/bin/bash
# Install documentation tools: pandoc, LaTeX (lightweight)

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

# Pandoc - universal document converter
apt_install pandoc

# LaTeX - lightweight installation for PDF generation
# texlive-latex-recommended is ~500MB, much smaller than texlive-full (~5GB)
apt_install texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra

success "Documentation tools installed"
