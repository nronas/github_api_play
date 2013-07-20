module Github
  class User
    include HTTParty
    base_uri "#{Github.base_uri}/users"

    def self.find(username)
      user_info = get "/#{username}"
      raise "GithubAPI returns: #{user_info["message"]}" if user_info["message"]

      user_info.each do |key, value|
        method_name = key == "login" ? "username" : key
        define_method method_name do
          value
        end
      end

      self.new
    end

    def repos
      return @repos if @repos
      @repos = Github::Repos.all(:user => self)
    end

    def prefered_language
      languages = languages_of(repos)
      prefered_lang_info = count_groups_of(languages).sort_by{ |language, count| count }.last

      if prefered_lang_info.nil? || prefered_lang_info.first.nil?
        "none"
      else
        prefered_lang_info.first
      end
    end

    private

    def count_groups_of(collection)
      collection.group_by{ |l| l }.inject({}) do |h, (k,v)|
        h[k] = v.size
        h
      end
    end

    def languages_of(repos)
      repos.map{|repo| repo["language"] }
    end
  end
end
