module Iterable
  ##
  #
  # Interact with /inApp API endpoints
  #
  # @example Creating in app endpoint object
  #   # With default config
  #   in_app = Iterable::InApp.new
  #
  #   # With custom config
  #   conf = Iterable::Config.new(token: 'new-token')
  #   in_app = Iterable::InApp.new(config)
  class InApp < ApiResource
    ##
    #
    # Get in-app messages for a user by email
    #
    # @param email [String] *required* Email of user who received the message to view. Required if no user_id present.
    # @param count [Integer] Number of messages to return, defaults to 1
    # @param attrs [Hash] Hash of query attributes like platform, SDKVersion, etc.
    #
    # @return [Iterable::Response] A response object
    def messages_for_email(email, count: 1, **attrs)
      attrs[:email] = email
      attrs[:count] = count
      messages(attrs)
    end

    ##
    #
    # Get in-app messages for a user by user_id
    #
    # @param email [String] *required* Email of user who received the message to view. Required if no user_id present.
    # @param count [Integer] Number of messages to return, defaults to 1
    # @param attrs [Hash] Hash of query attributes like platform, SDKVersion, etc.
    #
    # @return [Iterable::Response] A response object
    def messages_for_user_id(user_id, count: 1, **attrs)
      attrs[:userId] = user_id
      attrs[:count] = count
      messages(attrs)
    end

      ##
      #
      # Send an In-App notification to a specific user. User Email or ID along
      # with campaign ID must be provided
      #
      # @param email [String] (optional) User email used to identify user
      # @param campaign_id [Integer] Campaign ID 
      # @param attrs [Hash] Additional data to update or add
      #
      # @return [Iterable::Response] A response object
      #
    def target(email: nil, campaign_Id:, attrs:{})
      if email
        attrs['recipientEmail'] = email
      end
      attrs['campaignId'] = campaign_Id
      Iterable.request(conf, '/inApp/target').post(attrs)
    end


      ##
      #
      # Cancel an In App notification sent to a specific user
      # Must include either an email address AND campaignId, or 
      # just a scheduledMessageId provided in the attrs
      #
      # @param email [String] User email to cancel push 
      # @param campaignId [Integer] campaignID used to cancel push
      # @param attrs [Hash] Additional data to update or add
      #
      # @return [Iterable::Response] A response object
      #
      # @note An email or UserId is required
      def cancel(email: nil, campaign_Id: nil, attrs:{})
        if email
          attrs['email'] = email
        end

        if campaign_Id
          attrs['campaignId'] = campaign_Id
        end
        Iterable.request(conf, '/push/cancel').post(attrs)
      end

    private def messages(**attrs)
      Iterable.request(conf, '/inApp/getMessages', attrs).get
    end
  end
end
