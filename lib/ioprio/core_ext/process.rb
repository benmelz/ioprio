# frozen_string_literal: true

module Ioprio
  module CoreExt
    module Process
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def ioprio_get(which, who); end

        def ioprio_set(which, who, priority); end
      end
    end
  end
end

Process.include Ioprio::CoreExt::Process
