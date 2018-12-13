require "gitlab"

exit unless ENV["GITLAB_TOKEN"]?
exit unless ENV["GITLAB_HOST"]?

module Laborg
  VERSION = "0.1.0"
  class Main
    def initialize
      endpoint = "#{ENV["GITLAB_HOST"]}/api/v4"
      token = ENV["GITLAB_TOKEN"]
    end
  end
end

Laborg::Main.new

