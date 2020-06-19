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
      - uses: julia-actions/julia-docdeploy@releases/v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          DOCUMENTER_KEY: ${{ secrets.DOCUMENTER_KEY }}
```

You need `DOCUMENTER_KEY` for deployement, which you can generate using DocumenterTools:
```
julia> using DocumenterTools, YourPackage
julia> DocumenterTools.genkeys(YourPackage)
```
