module Laborg
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
