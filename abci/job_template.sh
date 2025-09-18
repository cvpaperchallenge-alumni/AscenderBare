#!/bin/bash
#PBS -q rt_HG
#PBS -l select=1
#PBS -l walltime=12:00:00

# Fail fast on common errors
set -euo pipefail

# Move to the job submission working directory
cd "${PBS_O_WORKDIR}" || exit 1

# Configure log destination (we suppress PBS .o/.e and use our own log)
export OUTPUTS_DIRPATH="${PWD}/outputs/${PBS_JOBNAME}.${PBS_JOBID}"
mkdir -p "$OUTPUTS_DIRPATH"
export LOG_FILE_PATH="${OUTPUTS_DIRPATH}/abci.log"
exec >"$LOG_FILE_PATH" 2>&1

# Initialize environment modules (ABCI)
# https://docs.abci.ai/v3/ja/environment-modules/
# shellcheck disable=SC1091
source /etc/profile.d/modules.sh

# Load required modules
# Please add modules if needed like below
module load cuda/12.6/12.6.1

# Ensure 'mise' is available
if ! command -v mise >/dev/null 2>&1; then
	echo "Error: mise is not installed. Aborting job."
	exit 1
fi

# Ensure mise project configuration exists
if [ ! -f "${PWD}/.mise.toml" ]; then
	echo "Error: .mise.toml not found in ${PWD}. Aborting job."
	exit 1
fi

# Activate directory-aware shims for bash
eval "$(mise activate bash)"
# Keep tool installs local to the project for reproducibility
export MISE_DATA_DIR="${PWD}/.mise"
# Trust this directory's configuration
mise trust "${PWD}/.mise.toml"
# Install tools defined in .mise.toml
mise install -y
# Show tools currently active for this directory
echo "=== Installed tools (mise) ==="
mise ls --current

# Create/use a project-local Python virtual environment with uv
mise exec -- uv sync

# List installed Python packages inside the venv
echo "=== Installed Python packages (.venv) ==="
mise exec -- uv tree -d 1

# Run the task using the venv (ensure the correct Python is used)
mise exec -- uv run python src/sample.py
