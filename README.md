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

If you only want to add this prefix on certain builds, you can [include additional values into a combination](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#example-including-additional-values-into-combinations) of your build matrix, e.g.:

```yaml
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macOS-latest]
        version: ['1.0', '1', 'nightly']
        arch: [x64]
        include:
          - os: ubuntu-latest
            prefix: xvfb-run
    steps:
    # ...
      - uses: julia-actions/julia-docdeploy@v1
        with:
          prefix: ${{ matrix.prefix }}
    # ...
```

This will add the prefix `xvfb-run` to all builds where the `os` is `ubuntu-latest`.
