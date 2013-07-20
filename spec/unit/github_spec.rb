require_relative '../../spec_helper'

describe Github do
  it "does include HTTParty" do
    described_class.included_modules.should include(HTTParty)
  end

  it "sets up a base_uri" do
    described_class.base_uri.should match("https://api.github.com")
  end
end
