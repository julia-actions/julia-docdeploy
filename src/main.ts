import * as core from '@actions/core';
import * as exec from '@actions/exec'

async function run() {
  try {
    await exec.exec('julia', ['--color=yes', '--project=docs/', '-e', 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'])
    await exec.exec('julia', ['--color=yes', '--project=docs/', 'docs/make.jl'])
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
