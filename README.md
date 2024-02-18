# julia-docdeploy

## Usage
```yaml
name: Documenter
on:
  push:
    branches: [main, master]
    tags: [v*]
  pull_request:

jobs:
  Documenter:
    permissions:
      contents: write
      statuses: write
    name: Documentation
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: julia-actions/julia-buildpkg@v1  # if package requires Pkg.build()
      - uses: julia-actions/julia-docdeploy@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

If you need to build your documentation on a particular Julia version, you can insert

```
      - uses: julia-actions/setup-julia@v1
        with:
          version: nightly               # replace this with whatever version you need
          show-versioninfo: true         # this causes versioninfo to be printed to the action log
```

as the first entry after `steps:`.

### Prefixing the Julia command

In some packages, you may want to prefix the `julia` command with another command, e.g. for running tests of certain graphical libraries with `xvfb-run`.
In that case, you can add an input called `prefix` containing the command that will be inserted to your workflow:

```yaml
      - uses: julia-actions/julia-docdeploy@v1
        with:
          prefix: xvfb-run
```

### Customizing installation of package into docs environment

In some packages, you may want to install the package yourself into the docs environment. For example, if the package is in a subdirectory (but the docs environment is still top-level). In this case, you can pass `install-package: false`.

```yaml
      - uses: julia-actions/julia-docdeploy@v1
        with:
          install-package: false
```

### Setting terminal width

For some doctests, the default terminal width of GitHub Runners is too narrow.
To change this, set the `COLUMNS` environment variable.

```yaml
      - uses: julia-actions/julia-docdeploy@v1
        env:
          COLUMNS: '200'
```
