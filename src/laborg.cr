require "gitlab"
require "clim"
require "json"

exit unless ENV["GITLAB_TOKEN"]?
exit unless ENV["GITLAB_HOST"]?

module Laborg
  VERSION = "0.1.0"
  class Main
    def initialize
      endpoint = "#{ENV["GITLAB_HOST"]}/api/v4"
      token = ENV["GITLAB_TOKEN"]
      @client = Gitlab.client(endpoint, token)
    end

    def plan
      @client.groups.to_json
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
