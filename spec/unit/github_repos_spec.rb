require_relative '../../spec_helper'

describe Github::Repos do
  it { should be_kind_of(HTTParty) }
  let(:user) do
    user = Github::User.new
    user.stub(:username => "test")
    user.stub(:public_repos => 1)
    user
  end

  context "user has public repos" do
    it "does return user repos" do
      described_class.should_receive(:get).with("#{Github.base_uri}/users/#{user.username}/repos").and_return([{"name" => "test_repo"}])

      described_class.all(:user => user).should == [{"name" => "test_repo"}]
    end
  end

  context "user has no public repos" do
    it "does return an empty collection" do
      user.stub(:public_repos => 0)

      described_class.all(:user => user).should be_empty
    end
  end
end
