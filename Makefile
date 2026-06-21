SHELL := /bin/bash

VENV_DIR ?= .venv
PYTHON ?= python3
KERNEL_NAME ?= snowflake-auto-classification
NOTEBOOK ?= auto_classification_demo.ipynb

PIP := $(VENV_DIR)/bin/pip
VENV_PYTHON := $(VENV_DIR)/bin/python

.PHONY: help setup venv kernel validate clean

help:
	@echo "Targets:"
	@echo "  make setup     - run venv, kernel registration, and validation"
	@echo "  make venv      - create venv and install notebook dependencies"
	@echo "  make kernel    - register Jupyter kernel for this venv"
	@echo "  make validate  - execute first two code cells in the notebook"
	@echo "  make clean     - remove local virtual environment"

setup: venv kernel validate

venv:
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo "Error: $(PYTHON) not found in PATH."; exit 1; }
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "Creating virtual environment at $(VENV_DIR)"; \
		$(PYTHON) -m venv $(VENV_DIR) || { \
			echo "Error: failed to create virtual environment."; \
			echo "Hint (Debian/Ubuntu): sudo apt install python3-venv"; \
			exit 1; \
		}; \
	fi
	@test -x "$(VENV_PYTHON)" || { echo "Error: $(VENV_PYTHON) was not created."; exit 1; }
	$(VENV_PYTHON) -m pip install --upgrade pip
	$(PIP) install jupyter ipykernel nbformat nbclient ipython-sql snowflake-sqlalchemy

kernel: venv
	$(VENV_PYTHON) -m ipykernel install --user --name "$(KERNEL_NAME)" --display-name "Python ($(KERNEL_NAME))"

validate: venv
	$(VENV_PYTHON) scripts/validate_first_two_code_cells.py --notebook "$(NOTEBOOK)" --count 2

clean:
	rm -rf $(VENV_DIR)
	@echo "Removed $(VENV_DIR)."
