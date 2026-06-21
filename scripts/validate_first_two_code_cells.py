#!/usr/bin/env python3
import argparse
from pathlib import Path

import nbformat
from nbclient import NotebookClient


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Execute the first N code cells from a notebook to validate startup."
    )
    parser.add_argument("--notebook", required=True, help="Path to notebook file")
    parser.add_argument(
        "--count",
        type=int,
        default=2,
        help="Number of code cells to execute (default: 2)",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=300,
        help="Per-cell execution timeout in seconds (default: 300)",
    )
    args = parser.parse_args()

    notebook_path = Path(args.notebook)
    if not notebook_path.exists():
        raise FileNotFoundError(f"Notebook not found: {notebook_path}")

    nb = nbformat.read(notebook_path, as_version=4)
    code_cells = [cell for cell in nb.cells if cell.get("cell_type") == "code"]

    if len(code_cells) < args.count:
        raise ValueError(
            f"Notebook has only {len(code_cells)} code cell(s), requested {args.count}."
        )

    validation_nb = nbformat.v4.new_notebook(
        cells=code_cells[: args.count],
        metadata=nb.metadata,
    )

    client = NotebookClient(validation_nb, timeout=args.timeout)
    client.execute()

    print(
        f"Validation succeeded: executed first {args.count} code cells in {notebook_path}."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
