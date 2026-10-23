# Security dependency update — 2026-10-24

Update: uv 0.13.4.

The eMudhra incident requires updating application-bundled CA stores as well as
the operating system. Frozen environments must be recreated from the reviewed
updated lock; refreshing only a global tool does not update an existing venv
or container. Rebuild affected container images with fresh base images and
package metadata before reuse. Existing experiment snapshots remain historical
evidence; do not reuse their network clients without remediation.

This change preserves model code, data, experimental results and unrelated
package versions. It does not certify historical experiments, rebuild deployed
images, or authorize a deployment.

## Evidence and verification

Before the change, `mise ls --json` selected a version below the official
security release. The security-floor assertion failed. After the change the
same resolution check selects the patched version and passes. Existing runtime
major/minor selections for unrelated tools are preserved.

## Primary sources

- [Mozilla incident response](https://blog.mozilla.org/security/2026/10/20/protecting-firefox-users-following-the-compromise-of-emudhra-intermediate-certificates/)
- [Python security guidance](https://discuss.python.org/t/information-for-python-users-regarding-emudhra-emsign-ca-certificate-security-incident/109576)
- [uv security release](https://github.com/astral-sh/uv/releases/tag/0.13.4)
- [Node.js security release](https://nodejs.org/en/blog/vulnerability/october-2026-security-releases)

See the pull request for repository-specific test results and limitations.

## Local validation

`uv run --frozen pytest tests`: 1 passed. Ruff lint/format and mypy passed.
