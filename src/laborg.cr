require "gitlab"
require "clim"
require "json"
require "yaml"
require "./laborg/version"
require "./laborg/gitlab/*"
require "./laborg/cli"

exit unless ENV["GITLAB_TOKEN"]?
exit unless ENV["GITLAB_HOST"]?

module Laborg
  RECURSIVE_LEVEL  = 1
  LOCAL_STATE_FILE = "./laborg.state"

  class Main
    def initialize
      endpoint = "#{ENV["GITLAB_HOST"]}/api/v4"
      token = ENV["GITLAB_TOKEN"]
      @client = ::Gitlab.client(endpoint, token)
      @remote = Gitlab::Groups.new
      i = 0
      loop do
        result = @client.groups({"page" => i})
        if result.size == 0
          break
        else
          @remote = @remote + Gitlab::Groups.from_json(result.to_json)
        end
        i = i + 1
      end
      @remote.reject! { |group| group.full_path.count("/") > RECURSIVE_LEVEL }
      unless File.exists?(LOCAL_STATE_FILE)
        File.write(LOCAL_STATE_FILE, @remote.to_yaml)
      end
      @local = Gitlab::Groups.from_yaml(File.read(LOCAL_STATE_FILE))
    end

    def plan
      @local.each do |group|
        if group.id
          puts @client.group(group.id)
        else
          group.flag = true
        end
      end
    end

    def apply
      @local.each do |group|
        if group.description == ""
          params = {"description" => group.name, "visibility" => group.visibility}
          puts @client.edit_group(group.id, params)
        end
      end
      # @client.create_group("GitLab-Group", "gitlab-path", params)
      # @client.edit_group(id, params)
    end
  end
end
