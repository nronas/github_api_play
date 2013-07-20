module Github
  class Repos
    include HTTParty

    def self.all(options = {})
      user = options[:user]
      return [] if user.nil? || user.public_repos == 0

      @repos = get "#{Github.base_uri}/users/#{user.username}/repos"
    end
  end
end
