# the action's setup steps should leave caches that this build can use
Base.isprecompiled(Base.identify_package("Documenter")) ||
    error("Documenter has no cache this build can use, so it would be precompiled again")

using Documenter, DocDeployExample, Logging

# the action sets its own logger before running this file
nameof(typeof(Logging.global_logger())) === :GitHubActionsLogger ||
    error("expected the action's logger, got $(typeof(Logging.global_logger()))")

DocMeta.setdocmeta!(DocDeployExample, :DocTestSetup, :(using DocDeployExample); recursive = true)
makedocs(; sitename = "DocDeployExample", modules = [DocDeployExample], remotes = nothing)
