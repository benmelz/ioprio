# frozen_string_literal: true

require "ioprio"

RSpec.describe Ioprio do
  it "has a version number" do
    expect(Ioprio::VERSION).not_to be_nil
  end
end
