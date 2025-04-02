# frozen_string_literal: true

module Ioprio
  module CoreExt
    module Process
      # actual values are initialized in C extension
      # rubocop:disable Lint/LiteralAsCondition
      IOPRIO_CLASS_NONE = _ if false
      IOPRIO_CLASS_RT = _ if false
      IOPRIO_CLASS_BE = _ if false
      IOPRIO_CLASS_IDLE = _ if false

      IOPRIO_WHO_PROCESS = _ if false
      IOPRIO_WHO_PGRP = _ if false
      IOPRIO_WHO_USER = _ if false
      # rubocop:enable Lint/LiteralAsCondition

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
