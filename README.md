# Snowflake Auto-Classification Demo

This repository contains a Jupyter notebook demo for Snowflake auto-classification:

- `auto_classification_demo.ipynb`
- `Makefile` for environment setup and validation
- `scripts/validate_first_two_code_cells.py` for quick notebook startup validation

## Prerequisites

- Python 3.10+ (tested with 3.12)
- `python3-venv` package installed
- Snowflake account access
- Snowflake Python connector profile in `~/.snowflake/connections.toml`

On Debian/Ubuntu, if venv creation fails:

```bash
sudo apt install python3-venv
```

## Quick Start

Run full setup (create venv, register kernel, validate first 2 code cells):

```bash
make setup
```

Or run step-by-step:

```bash
make venv
make kernel
make validate
```

Clean local virtual environment:

```bash
make clean
```

## Makefile Targets

- `make setup`: runs `venv`, `kernel`, and `validate`
- `make venv`: creates `.venv` and installs dependencies
- `make kernel`: registers Jupyter kernel `snowflake-auto-classification`
- `make validate`: executes first 2 code cells in the notebook
- `make clean`: removes `.venv`

## Snowflake Connection (connections.toml)

The notebook uses Snowflake named connections.

1. Create or update `~/.snowflake/connections.toml`:

```toml
[default]
account = "<your_account>"
user = "<your_user>"
authenticator = "externalbrowser"
warehouse = "<your_warehouse>"
database = "<your_database>"
schema = "<your_schema>"
role = "<your_role>"
```

2. Optional: use a non-default profile:

```bash
export SNOWFLAKE_CONNECTION_NAME=auto_classification_demo
```

The notebook connection cell reads `SNOWFLAKE_CONNECTION_NAME` and falls back to `default`.

## Running the Notebook

1. Open `auto_classification_demo.ipynb` in VS Code.
2. Select kernel `Python (snowflake-auto-classification)`.
3. Run setup cells first:
   - Cell 3: load SQL magic
   - Cell 4: connect to Snowflake via `connections.toml`
4. Run remaining SQL cells.

## Troubleshooting

### Error: `UsageError: Cell magic %%sql not found`

Cause: SQL magic extension not loaded.

Fix: run the SQL setup cell (Cell 3).

### Error: `UsageError: unrecognized arguments: -r`

Cause: `ipython-sql` does not support `%%sql -r ...` headers.

Fix: use `%%sql` only.

### venv creation or package install issues

- Ensure Python is available: `python3 --version`
- Recreate environment:

```bash
make clean
make venv
```
