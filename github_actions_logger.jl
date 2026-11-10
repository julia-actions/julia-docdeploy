# Prints log records as GitHub Actions workflow commands, so that warnings and errors show
# up as annotations. This is the logger from GitHubActions.jl. It is copied here so that
# the docs build does not need a second environment, whose dependency versions would be
# mixed with those of the docs environment.

using Logging: Logging, AbstractLogger, LogLevel, Debug, Info, Warn, Error

const showvalue = VERSION ≥ v"1.11.0-DEV.1786" ? Base.CoreLogging.showvalue : Logging.showvalue

cmd_value(::Nothing) = ""
cmd_value(x) = string(x)

esc_data(val) = replace(replace(replace(cmd_value(val), '%' => "%25"), '\r' => "%0D"), '\n' => "%0A")
esc_prop(val) = replace(replace(esc_data(val), ':' => "%3A"), ',' => "%2C")

function command(cmd, props, val)
    s = "::" * cmd
    isempty(props) || (s *= ' ' * join([string(k, "=", esc_prop(v)) for (k, v) in pairs(props)], ','))
    println(s, "::", esc_data(val))
end

struct GitHubActionsLogger <: AbstractLogger
    level::LogLevel
end

# match the log level to GitHub Actions' debug logging setting
function GitHubActionsLogger()
    env_str = get(ENV, "RUNNER_DEBUG", "false")
    is_debug = env_str == "1" || something(tryparse(Bool, env_str), false)
    return GitHubActionsLogger(is_debug ? Debug : Info)
end

Logging.catch_exceptions(::GitHubActionsLogger) = true
Logging.min_enabled_level(logger::GitHubActionsLogger) = logger.level
Logging.shouldlog(::GitHubActionsLogger, args...) = true

function Logging.handle_message(::GitHubActionsLogger, level, msg, _module, group, id, file, line;
                                location=nothing, kwargs...)
    file, line = something(location, (file, line))
    workspace = get(ENV, "GITHUB_WORKSPACE", nothing)
    if workspace !== nothing && file !== nothing
        file = relpath(file, workspace) # annotations need a path relative to the repository
    end
    message = string(msg)
    for (k, v) in kwargs
        result = sprint(showvalue, v)
        message *= "\n  $k = " * (occursin('\n', result) ? replace("\n" * result, '\n' => "\n    ") : result)
    end
    if level === Info
        println(message)
    else
        cmd = level === Debug ? "debug" : level === Warn ? "warning" : level === Error ? "error" : "notice"
        command(cmd, (file=file, line=line), message)
    end
end

Logging.global_logger(GitHubActionsLogger())
