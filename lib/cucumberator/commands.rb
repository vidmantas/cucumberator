require 'cucumberator/commands/exit'
require 'cucumberator/commands/exit_all'
require 'cucumberator/commands/help'
require 'cucumberator/commands/where'
require 'cucumberator/commands/steps'
require 'cucumberator/commands/last_step'
require 'cucumberator/commands/save'
require 'cucumberator/commands/undo'
require 'cucumberator/commands/next'

# todo: magic!
module Cucumberator::Commands
  AVAILABLE = %w(exit exit-all help last-step save undo next where steps)
end
