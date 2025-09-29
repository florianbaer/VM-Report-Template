# LaTeX VM Report Template Makefile
# Provides convenient commands for building, cleaning, and managing the thesis

# Configuration
MAIN_TEX = main.tex
OUTPUT_DIR = build
PDF_NAME = thesis.pdf
FINAL_PDF = $(OUTPUT_DIR)/$(PDF_NAME)

# LaTeX tools
LATEXMK = latexmk
PDFLATEX = pdflatex
BIBER = biber

# Makefile settings
.PHONY: all build clean distclean watch configure help install-deps lint wordcount
.DEFAULT_GOAL := help

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

## Main targets

all: build ## Build the complete thesis (default)

build: $(FINAL_PDF) ## Build the PDF using latexmk

$(FINAL_PDF): $(MAIN_TEX) config.tex $(shell find include/ -name "*.tex" 2>/dev/null) bibliography.bib
	@echo "$(GREEN)Building thesis PDF...$(NC)"
	@mkdir -p $(OUTPUT_DIR)
	$(LATEXMK) -pdf -output-directory=$(OUTPUT_DIR) -interaction=nonstopmode $(MAIN_TEX)
	@echo "$(GREEN)✅ Build complete: $(FINAL_PDF)$(NC)"

quick: ## Quick build without bibliography
	@echo "$(YELLOW)Quick build (no bibliography)...$(NC)"
	@mkdir -p $(OUTPUT_DIR)
	$(PDFLATEX) -output-directory=$(OUTPUT_DIR) -interaction=nonstopmode $(MAIN_TEX)
	@echo "$(GREEN)✅ Quick build complete$(NC)"

watch: ## Watch files and rebuild automatically on changes
	@echo "$(GREEN)Watching files for changes...$(NC)"
	@echo "$(YELLOW)Press Ctrl+C to stop$(NC)"
	$(LATEXMK) -pdf -pvc -output-directory=$(OUTPUT_DIR) -interaction=nonstopmode $(MAIN_TEX)

## Configuration and setup

configure: ## Run configuration wizard
	@echo "$(GREEN)Starting configuration wizard...$(NC)"
	python3 configure.py

install-deps: ## Install required Python dependencies for tools
	@echo "$(GREEN)Installing Python dependencies...$(NC)"
	pip3 install --user pygments

check-config: ## Check if configuration is complete
	@echo "$(GREEN)Checking configuration...$(NC)"
	@grep -q "Your Name" config.tex && echo "$(RED)❌ Author name not configured$(NC)" || echo "$(GREEN)✅ Author name configured$(NC)"
	@grep -q "Your Thesis Title" config.tex && echo "$(RED)❌ Thesis title not configured$(NC)" || echo "$(GREEN)✅ Thesis title configured$(NC)"
	@grep -q "advisor@university.com" config.tex && echo "$(RED)❌ Advisor email not configured$(NC)" || echo "$(GREEN)✅ Advisor email configured$(NC)"

## Development and quality

lint: ## Run LaTeX linting (requires chktex)
	@echo "$(GREEN)Running LaTeX linting...$(NC)"
	@command -v chktex >/dev/null 2>&1 || { echo "$(RED)chktex not found. Install with: apt install chktex$(NC)"; exit 1; }
	chktex -v0 $(MAIN_TEX)
	@echo "$(GREEN)✅ Linting complete$(NC)"

wordcount: ## Count words in the thesis
	@echo "$(GREEN)Counting words...$(NC)"
	@command -v texcount >/dev/null 2>&1 || { echo "$(RED)texcount not found. Install with: apt install texlive-extra-utils$(NC)"; exit 1; }
	texcount -inc -total $(MAIN_TEX)

spellcheck: ## Run spell checking (requires aspell)
	@echo "$(GREEN)Running spell check...$(NC)"
	@command -v aspell >/dev/null 2>&1 || { echo "$(RED)aspell not found. Install with: apt install aspell aspell-en$(NC)"; exit 1; }
	@find include/ -name "*.tex" -exec aspell check {} \;
	@echo "$(GREEN)✅ Spell check complete$(NC)"

## Cleaning

clean: ## Clean build artifacts
	@echo "$(GREEN)Cleaning build artifacts...$(NC)"
	$(LATEXMK) -c -output-directory=$(OUTPUT_DIR)
	@find . -name "*.aux" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@find . -name "*.out" -delete 2>/dev/null || true
	@find . -name "*.toc" -delete 2>/dev/null || true
	@find . -name "*.bbl" -delete 2>/dev/null || true
	@find . -name "*.blg" -delete 2>/dev/null || true
	@find . -name "*.bcf" -delete 2>/dev/null || true
	@find . -name "*.run.xml" -delete 2>/dev/null || true
	@find . -name "*.fls" -delete 2>/dev/null || true
	@find . -name "*.fdb_latexmk" -delete 2>/dev/null || true
	@find . -name "*.synctex.gz" -delete 2>/dev/null || true
	@echo "$(GREEN)✅ Cleanup complete$(NC)"

distclean: clean ## Clean everything including output directory
	@echo "$(GREEN)Deep cleaning...$(NC)"
	$(LATEXMK) -C -output-directory=$(OUTPUT_DIR)
	@rm -rf $(OUTPUT_DIR)
	@echo "$(GREEN)✅ Deep cleanup complete$(NC)"

## Information

info: ## Show build information
	@echo "$(GREEN)LaTeX VM Report Template$(NC)"
	@echo "Main file: $(MAIN_TEX)"
	@echo "Output directory: $(OUTPUT_DIR)"
	@echo "Final PDF: $(FINAL_PDF)"
	@echo ""
	@echo "LaTeX tools:"
	@command -v $(LATEXMK) >/dev/null 2>&1 && echo "  ✅ latexmk available" || echo "  ❌ latexmk not found"
	@command -v $(PDFLATEX) >/dev/null 2>&1 && echo "  ✅ pdflatex available" || echo "  ❌ pdflatex not found"
	@command -v $(BIBER) >/dev/null 2>&1 && echo "  ✅ biber available" || echo "  ❌ biber not found"
	@command -v python3 >/dev/null 2>&1 && echo "  ✅ python3 available" || echo "  ❌ python3 not found"

help: ## Show this help message
	@echo "$(GREEN)LaTeX VM Report Template - Available Commands:$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(GREEN)Usage examples:$(NC)"
	@echo "  make configure    # Set up your thesis information"
	@echo "  make build        # Build the complete thesis"
	@echo "  make watch        # Watch and rebuild on changes"
	@echo "  make clean        # Clean temporary files"
	@echo ""