ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ARG PROJECT_NAME=ascender-bare
ARG USER_NAME=challenger
ARG GROUP_NAME=challengers
ARG UID=1000
ARG GID=1000
ARG USER_DIRECTORY=/home/${USER_NAME}
ARG APPLICATION_DIRECTORY=${USER_DIRECTORY}/${PROJECT_NAME}
ARG RUN_UV_SYNC_AT_BUILD_TIME="false"

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="C.UTF-8" \
    LANG="C.UTF-8" \
    PYTHONPATH=${APPLICATION_DIRECTORY}

RUN apt update -y && apt install --no-install-recommends -y software-properties-common \
    && apt-get update && apt-get install -y \
    build-essential curl git openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add user. Without this, following process is executed as admin.
RUN groupadd -g ${GID} ${GROUP_NAME} \
    && useradd -m -s /bin/bash -u ${UID} -g ${GID} ${USER_NAME}

USER ${USER_NAME}
WORKDIR ${APPLICATION_DIRECTORY}

# Install MISE.
RUN curl https://mise.run | sh
ENV PATH=${APPLICATION_DIRECTORY}/.mise/shims:${USER_DIRECTORY}/.local/bin:${PATH} \
    MISE_DATA_DIR=${APPLICATION_DIRECTORY}/.mise

# Copy configuration files for mise
COPY --chown=${UID}:${GID} .mise.* ./
RUN mise trust ${APPLICATION_DIRECTORY}/mise.toml

# Copy configuration files for uv
COPY --chown=${UID}:${GID} pyproject.toml uv.lock ./

# If the .mise or .venv directories generated during the build are placed under the APPLICATION_DIRECTORY,
# they will be overwritten at runtime by the mounted volume. To avoid this, we temporarily move them under 
# the HOME during the build, and then move them back to APPLICATION_DIRECTORY after starting the container. 
# This way, .mise and .venv can still be used in CI jobs and similar environments.
RUN test ${RUN_UV_SYNC_AT_BUILD_TIME} = "true" && mise install -y || echo "skip to run mise install."
RUN test ${RUN_UV_SYNC_AT_BUILD_TIME} = "true" && mise exec -- uv sync || echo "skip to run uv sync."
RUN test ${RUN_UV_SYNC_AT_BUILD_TIME} = "true" && mv ${APPLICATION_DIRECTORY}/.mise ${HOME}/.mise || echo "skip to move .mise."
RUN test ${RUN_UV_SYNC_AT_BUILD_TIME} = "true" && mv ${APPLICATION_DIRECTORY}/.venv ${HOME}/.venv || echo "skip to move .venv."
