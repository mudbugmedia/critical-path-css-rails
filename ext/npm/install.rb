require_relative '../../lib/npm_commands'

NpmCommands.new.install('--production', '.') ||
  raise('Error while installing npm dependencies')
