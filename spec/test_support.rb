require 'factory_bot'

module Finale
  class TestSupport
    def self.load_definitions
      FactoryBot.definition_file_paths ||= []
      # Unshift ensures these factories are defined prior to yours, allowing you to FactoryBot.modify them.
      FactoryBot.definition_file_paths.unshift(Finale.root.join('spec', 'factories'))
    end
  end
end
