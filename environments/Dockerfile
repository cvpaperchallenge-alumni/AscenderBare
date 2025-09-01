ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ARG PROJECT_NAME=ascender-bare
ARG USER_NAME=challenger
ARG GROUP_NAME=challengers
ARG UID=1000
ARG GID=1000
ARG APPLICATION_DIRECTORY=/home/${USER_NAME}/${PROJECT_NAME}
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
ENV HOME="/home/${USER_NAME}" \
    PATH=/home/${USER_NAME}/.local/share/mise/shims:/home/${USER_NAME}/.local/bin:${PATH}
RUN curl https://mise.run | sh \
    && ${HOME}/.local/bin/mise --version
RUN echo 'eval "$(${HOME}/.local/bin/mise activate bash)"' >> "${HOME}/.bashrc"

# Copy .mise.toml and .mise.lock
COPY --chown=${USER_NAME}:${GROUP_NAME} .mise.* ./
RUN ${HOME}/.local/bin/mise trust -y . \
    && ${HOME}/.local/bin/mise install -y

# If ${RUN_UV_SYNC_AT_BUILD_TIME} = "true", install Python package by uv and move .venv under ${HOME}.
# This process is for CI (GitHub Actions). To prevent overwrite by volume of docker compose, .venv is moved under ${HOME}.
RUN test ${RUN_UV_SYNC_AT_BUILD_TIME} = "true" && uv sync || echo "skip to run uv sync."
RUN test ${RUN_UV_SYNC_AT_BUILD_TIME} = "true" && mv ${APPLICATION_DIRECTORY}/.venv ${HOME}/.venv || echo "skip to move .venv."
