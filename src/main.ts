import * as core from '@actions/core';
import * as exec from '@actions/exec'

async function run() {
  try {
    await exec.exec('julia', ['--color=yes', '--project=docs/', '-e', 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'])
    // TODO Remove this once Documenter 0.24 is tagged
    await exec.exec('julia', ['--color=yes', '--project=docs/', '-e', 'using Pkg; Pkg.add(PackageSpec(name="Documenter", revision="master"))'])
    await exec.exec('julia', ['--color=yes', '--project=docs/', 'docs/make.jl'])
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
