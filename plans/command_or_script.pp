# Run either a command or a script. Fails if neither or both a command and script
# are specified.
#
# @param command The command to run.
# @param script The script to run.
# @param targets The targets to run the command or script on.
#
plan boltspec::command_or_script (
  TargetSpec       $targets,
  Optional[String] $command = undef,
  Optional[String] $script  = undef
) {
  if type($command) == Undef and type($script) == Undef {
    fail_plan('Must specify either command or script.')
  }
  elsif $command and $script {
    fail_plan('Cannot specify both command and script.')
  }
  elsif $command {
    return run_command($command, $targets)
  }
  else {
    return run_script($script, $targets)
  }
}
