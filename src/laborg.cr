require "gitlab"
require "clim"
require "json"

exit unless ENV["GITLAB_TOKEN"]?
exit unless ENV["GITLAB_HOST"]?

module Laborg
  VERSION = "0.1.0"

  alias Groups = Array(Group)
  class Group
    include JSON::Serializable
    property id : Int32
    property web_url : String
    property name : String
    property path : String
    property description : String
    property visibility : String
    property lfs_enabled : Bool
    property avatar_url : String?
    property request_access_enabled : Bool
    property full_name : String
    property full_path : String
    property parent_id : Int32?
    property ldap_cn : Nil
    property ldap_access : Nil
  end

  class Main
    def initialize
      endpoint = "#{ENV["GITLAB_HOST"]}/api/v4"
      token = ENV["GITLAB_TOKEN"]
      @client = Gitlab.client(endpoint, token)
    end

    def plan
      groups = Groups.new
      i = 0
      loop do
        result = @client.groups({"page" => i})
        if result.size == 0
          break
        else
          groups = groups + Groups.from_json(result.to_json)
        end
        i = i + 1
      end
      groups
    end

    def apply
      params = {"parent_id" => 70}
      @client.create_group("GitLab-Group", "gitlab-path", params)
    end

  end
  class Cli < Clim
    main do
      desc "Laborg CLI."
      run do |opts, args|
        opts.help # => help string
      end
      sub "plan" do
        desc "Generate an execution plan"
        run do |opts, args|
          core = Laborg::Main.new
          puts core.plan
        end
      end
      sub "apply" do
        desc "Builds or Changes the first level groups"
        run do |opts, args|
          core = Laborg::Main.new
          core.apply
        end
      end
    end
  end
end

Laborg::Cli.start(ARGV)
