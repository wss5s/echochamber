module Echochamber
  class RecipientSet < Hash

    include Validatable

    # Creates an Echochamber::RecipientSet object 
    #
    # @param [Hash] params SYMBOL-referenced Hash.  Role is required for the set. Either fax or email is required for each recipient member.
    # @option params [String] :recipientSetRole ['SIGNER' or 'APPROVER']: Specify the role of recipient set (REQUIRED)
    # @option params [Array] :recipientSetMemberInfos A list of emails of the recipients.  Populate with array of isntances of {Echochamber::RecipientSetMember Echochamber::RecipientSetMember}(REQUIRED)
    # @return [Echochamber::RecipientSet]

    def initialize(params)
      require_keys([:recipientSetRole, :recipientSetMemberInfos], params)
      merge!(params)
    end

  end
end

