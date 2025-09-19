# Use Ascender Bare with ABCI

When using Ascender Bare on ABCI, you will also need mise and direnv, so please refer to the [README](../../README.md) and install them on ABCI. In an interactive shell, you can directly use Ascender Bare for development.

When using Ascender Bare in ABCI batch jobs, you need to make some adjustments to the job script, so we have provided a template named `job_template.sh`. By running the `qsub` command from the project root directory as shown below, you can execute the template job script on ABCI.

```bash
% qsub -P <YOUR_GROUP> scripts/abci/job_template.sh
```

If the job runs, the logs should be output under the `outputs` directory.

There are two places in `job_template.sh` marked with `# >>> EDIT HERE >>> #`. By mainly editing these sections, users can create their own custom job scripts. In the other sections, the script mainly checks for the presence of mise and direnv, installs dependencies, and configures logging.