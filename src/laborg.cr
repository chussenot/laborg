require "gitlab"
require "clim"
require "json"
require "yaml"

exit unless ENV["GITLAB_TOKEN"]?
exit unless ENV["GITLAB_HOST"]?

module Laborg
  VERSION = "0.1.0"
  RECURSIVE_LEVEL = 3
  LOCAL_STATE_FILE = "./laborg.yml"

  alias Groups = Array(Group)
  class Group
    include JSON::Serializable
    include YAML::Serializable
    property name : String
    property id : Int32
    property parent_id : Int32?
    property web_url : String
    property path : String
    property description : String
    property visibility : String
    property full_name : String
    property full_path : String
  end

  class Main
    def initialize
      endpoint = "#{ENV["GITLAB_HOST"]}/api/v4"
      token = ENV["GITLAB_TOKEN"]
      @client = Gitlab.client(endpoint, token)
      @remote = Groups.new
      i = 0
      loop do
        result = @client.groups({"page" => i})
        if result.size == 0
          break
        else
          @remote = @remote + Groups.from_json(result.to_json)
        end
        i = i + 1
      end
      @remote.reject!{|group| group.full_path.count("/") > RECURSIVE_LEVEL }
      unless File.exists?(LOCAL_STATE_FILE)
        File.write(LOCAL_STATE_FILE, @remote.to_yaml)
      end
      @local = Groups.from_yaml(File.read(LOCAL_STATE_FILE))
    end

    def plan
      @local.each do |group|
        puts @client.group(group.id) if group.id
      end
    end

    def apply
      @local.each do |group|
        if group.description == ""
          params = {"description" => group.name, "visibility" => group.visibility }
          puts @client.edit_group(group.id, params)
        end
      end
      # @client.create_group("GitLab-Group", "gitlab-path", params)
      # @client.edit_group(id, params)
    end

  end
  class Cli < Clim
    main do
      desc "Laborg CLI."
      run do |opts, args|
        opts.help # => help string
      end
      sub "plan" do
        desc "Generate an execution plan and compare it"
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
