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
      - uses: actions/checkout@v7
      - uses: julia-actions/setup-julia@v3
        with:
          version: '1'                         # replace this with whatever version you need
          show-versioninfo: true               # this causes versioninfo to be printed to the action log
      - uses: julia-actions/cache@v3           # cache using https://github.com/julia-actions/cache
      - uses: julia-actions/julia-buildpkg@v1  # if package requires Pkg.build()
      - uses: julia-actions/julia-docdeploy@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

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

### Building docs for a package in a subdirectory

If the package and its `docs` folder are in a subdirectory of the repository, pass that directory as `project`.
The action then runs from there, so `docs/make.jl` and the package are found relative to it.

```yaml
      - uses: julia-actions/julia-docdeploy@v1
        with:
          project: lib/MyPackage
```

### Setting terminal width

For some doctests, the default terminal width of GitHub Runners is too narrow.
To change this, set the `COLUMNS` environment variable.

```yaml
      - uses: julia-actions/julia-docdeploy@v1
        env:
          COLUMNS: '200'
```
