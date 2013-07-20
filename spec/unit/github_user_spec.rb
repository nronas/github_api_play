require_relative '../../spec_helper'


describe Github::User do
  let(:valid_repos) { [{"language" => "Ruby"}, {"language" => "Erlang"}] }
  let(:repos_with_no_language) { [{"language" => nil}] }
  let(:empty_repos) { [] }

  it { should be_kind_of(HTTParty) }

  it "does modify the base_uri" do
    described_class.base_uri.should match("#{Github.base_uri}/users")
  end

  context "#find" do
    let(:username) { "test" }
    let(:valid_response) { {"login" => username} }
    let(:error_response) { {"message" => "ERROR"} }

    it "returns a user with existing username" do
      described_class.should_receive(:get).with("/#{username}").and_return(valid_response)
      described_class.find(username).should be_an_instance_of(described_class)
    end

    it "raises an exception when API returns error" do
      described_class.should_receive(:get).with("/#{username}").and_return(error_response)

      expect{ described_class.find(username) }.to raise_exception(Exception, "GithubAPI returns: #{error_response["message"]}")
    end

    it "defines instance methods from the response" do
      described_class.should_receive(:get).with("/#{username}").and_return(valid_response)

      user = described_class.find(username)
      user.should respond_to(:username)
    end
  end

  context "#repos" do
    let(:user)  { Github::User.new }
    let(:repos) { [{"name" => "test_repo"}] }

    it "does return the repos from this user" do
      Github::Repos.should_receive(:all).with(:user => user).and_return(repos)

     user.repos.should == repos
    end
  end

  context "#prefered_language" do
    let(:user) { Github::User.new }

    it "does return prefered_language for repos with language specified" do
      user.stub(:repos => valid_repos)

      user.prefered_language.should match("Erlang")
    end

    it "does return prefered_language = none if repos dominate language is nil" do
      user.stub(:repos => repos_with_no_language)

      user.prefered_language.should match("none")
    end

    it "does return prefered_language = none if user has no repos" do
      user.stub(:repos => empty_repos)

      user.prefered_language.should match("none")
    end
  end

  context "private methods" do
    let(:user) { Github::User.new }

    it "#count_groups_of" do
      user.send(:count_groups_of, ["Ruby", "Ruby", "Erlang"]).should == {"Ruby" => 2, "Erlang" => 1}
    end

    it "#languages_of" do
      user.send(:languages_of, valid_repos).should == ["Ruby", "Erlang"]
    end
  end
end
