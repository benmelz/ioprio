# frozen_string_literal: true

require "ioprio"

RSpec.describe Process do
  include ProcessHelpers

  it "defines a none class constant" do
    expect(described_class::IOPRIO_CLASS_NONE).to eq(0)
  end

  it "defines a realtime class constant" do
    expect(described_class::IOPRIO_CLASS_RT).to eq(1)
  end

  it "defines a best effort class constant" do
    expect(described_class::IOPRIO_CLASS_BE).to eq(2)
  end

  it "defines an idle class constant" do
    expect(described_class::IOPRIO_CLASS_IDLE).to eq(3)
  end

  it "defines a who process constant" do
    expect(described_class::IOPRIO_WHO_PROCESS).to eq(1)
  end

  it "defines a who process group constant" do
    expect(described_class::IOPRIO_WHO_PGRP).to eq(2)
  end

  it "defines a who user group constant" do
    expect(described_class::IOPRIO_WHO_USER).to eq(3)
  end

  describe ".ioprio_prio_class" do
    { "none" => 0, "realtime" => 1, "best effort" => 2, "idle" => 3 }.each do |class_name, value|
      it "decodes at the lower bound of the #{class_name} class" do
        priority = value << 13
        expect(described_class.ioprio_prio_class(priority)).to eq(value)
      end

      it "decodes at the upper bound of the #{class_name} class" do
        priority = (value << 13) + 2.pow(13) - 1
        expect(described_class.ioprio_prio_class(priority)).to eq(value)
      end
    end
  end

  describe ".ioprio_prio_data" do
    { "none" => 0, "realtime" => 1, "best effort" => 2, "idle" => 3 }.each do |class_name, value|
      it "decodes at the lower bound of the #{class_name} class" do
        priority = value << 13
        expect(described_class.ioprio_prio_data(priority)).to eq(0)
      end

      it "decodes at the upper bound of the #{class_name} class" do
        priority = (value << 13) + 2.pow(13) - 1
        expect(described_class.ioprio_prio_data(priority)).to eq(2.pow(13) - 1)
      end
    end
  end

  describe ".ioprio_prio_value" do
    { "none" => 0, "realtime" => 1, "best effort" => 2, "idle" => 3 }.each do |class_name, value|
      it "encodes at the lower bound of the #{class_name} class" do
        expect(described_class.ioprio_prio_value(value, 0)).to eq(value << 13)
      end

      it "encodes at the upper bound of the #{class_name} class" do
        priority = (value << 13) + 2.pow(13) - 1
        expect(described_class.ioprio_prio_value(value, 2.pow(13) - 1)).to eq((value << 13) + 2.pow(13) - 1)
      end
    end
  end

  describe ".ioprio_get" do
    it "returns the correct io priority" do
      priority = loop_script(prefix: "ionice --class 3") do |pid|
        described_class.ioprio_get(described_class::IOPRIO_WHO_PROCESS, pid)
      end
      expect(priority).to eq(24_583)
    end
  end

  describe ".ioprio_set" do
    it "sets the correct io priority" do
      ionice_priority = loop_script do |pid|
        described_class.ioprio_set(described_class::IOPRIO_WHO_PROCESS, pid, 24_576)
        `ionice --pid #{pid}`
      end
      expect(ionice_priority).to eq("idle\n")
    end
  end
end
