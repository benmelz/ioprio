# frozen_string_literal: true

require 'ioprio'

RSpec.describe Process do
  include ProcessHelpers

  it 'defines a who process constant' do
    expect(described_class::IOPRIO_WHO_PROCESS).to eq(1)
  end

  it 'defines a who process group constant' do
    expect(described_class::IOPRIO_WHO_PGRP).to eq(2)
  end

  it 'defines a who user group constant' do
    expect(described_class::IOPRIO_WHO_USER).to eq(3)
  end

  describe '.ioprio_get' do
    it 'returns the correct io priority' do
      priority = loop_script(prefix: 'ionice --class 3') do |pid|
        described_class.ioprio_get(described_class::IOPRIO_WHO_PROCESS, pid)
      end
      expect(priority).to eq(24_583)
    end
  end

  describe '.ioprio_set' do
    it 'sets the correct io priority' do
      ionice_priority = loop_script do |pid|
        described_class.ioprio_set(described_class::IOPRIO_WHO_PROCESS, pid, 24_576)
        `ionice --pid #{pid}`
      end
      expect(ionice_priority).to eq("idle\n")
    end
  end
end
