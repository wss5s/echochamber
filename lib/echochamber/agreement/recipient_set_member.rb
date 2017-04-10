module Echochamber
  class RecipientSetMember < Hash

    include Validatable

    # Creates an Echochamber::RecipientSetMember object 
    #
    # @param [Hash] params SYMBOL-referenced Hash.  Email is required for each recipient set member.
    # @option params [String] :email Emails of the recipient.(REQUIRED)
    # @return [Echochamber::RecipientSetMember]

    def initialize(params)
      require_keys([:email], params)
      merge!(params)
    end

  end
end

