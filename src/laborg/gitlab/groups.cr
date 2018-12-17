module Laborg
  module Gitlab
    alias Groups = Array(Group)

    class Group
      include JSON::Serializable
      include YAML::Serializable
      property name : String
      property id : Int32
      property parent_id : Int32?
      property description : String
      property visibility : String
      property full_path : String
      property flag : Bool?
    end
  end
end
