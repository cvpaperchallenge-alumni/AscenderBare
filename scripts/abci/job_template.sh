#!/bin/bash
#PBS -q rt_HG
#PBS -l select=1
#PBS -l walltime=12:00:00
#PBS -o /dev/null
#PBS -e /dev/null
#PBS -P <UPDATE_HERE_BY_YOUR_GROUP>

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
source /etc/profile.d/modules.sh

# Load required modules
# >>> EDIT HERE >>> #
module load cuda/12.6/12.6.1
# <<< #

#　Ensure　'direnv' is available
if ! command -v direnv >/dev/null 2>&1; then
    echo "Error: direnv is not installed. Aborting job."
    exit 1
fi

# Ensure .envrc exists
if [ ! -f "${PWD}/.envrc" ]; then
	echo "Error: .envrc not found in ${PWD}. Aborting job."
	exit 1
fi

# Allow loading environment variables from .envrc
# Update only the values of MISE_DATA_DIR and PATH for mise.
direnv allow "${PWD}/.envrc"
eval "$(direnv export bash)"

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
# >>> EDIT HERE >>> #
mise exec -- uv run python src/sample.py
# <<< #