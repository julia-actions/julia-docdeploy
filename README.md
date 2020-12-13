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
