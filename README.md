# julia-docdeploy

## Usage
```yaml
name: Documenter
on:
  push:
    branches: [master]
    tags: [v*]
  pull_request:

jobs:
  Documenter:
    name: Documentation
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: julia-actions/julia-buildpkg@latest
      - uses: julia-actions/julia-docdeploy@latest
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          DOCUMENTER_KEY: ${{ secrets.DOCUMENTER_KEY }}
```

You need `DOCUMENTER_KEY` for deployement, which you can generate using DocumenterTools:
```
julia> using DocumenterTools, YourPackage
julia> DocumenterTools.genkeys(YourPackage)
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
