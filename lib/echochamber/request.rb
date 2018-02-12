require 'rest-client'
require 'echochamber/agreement/request'
require 'echochamber/library_documents/request'
require 'echochamber/widget/request'

module Echochamber::Request
  class Failure < StandardError
    attr_reader :original_exception

    def initialize msg, original_exception
      @message = msg
      @original_exception = original_exception
    end
  end

  BASE_URL = 'https://api.na1.echosign.com/api/rest/v5'

  ENDPOINT = { 
    base_uri: BASE_URL + '/base_uris',
    user: BASE_URL + '/users',
    agreement: BASE_URL + '/agreements',
    reminder: BASE_URL + '/reminders',
    transientDocument: BASE_URL + '/transientDocuments',
    libraryDocument: BASE_URL + '/libraryDocuments',
    widget: BASE_URL + '/widgets',
    view: BASE_URL + '/views',
    search: BASE_URL + '/search',
    workflow: BASE_URL + '/workflows',
    group: BASE_URL + '/groups',
    megaSign: BASE_URL + '/megaSigns',
  }

  # Performs REST create_user operation
  #
  # @param body [Hash] Valid request body
  # @param token [String] Auth Token
  # @return [Hash] New user response body
  def self.create_user(body, token)
    endpoint = ENDPOINT.fetch(:user) 
    headers = { :content_type => :json, :accept => :json, 'Access-Token' => token}
    response = post(endpoint, body, headers)
    JSON.parse(response.body)
  end
  
  # Sends a reminder for an agreement.
  #
  # @param body [Hash] Valid request body
  # @param token [String] Auth Token
  # @return [Hash] Response body
  def self.create_reminder(token, body)
  endpoint = ENDPOINT.fetch(:reminder)
  headers = { :content_type => :json, :accept => :json, 'Access-Token' => token}
  response = post(endpoint, body, headers)
  JSON.parse(response.body)
  end

  # Performs REST create_transient_document operation
  #
  # @param token [String] Auth token  (REQUIRED)
  # @param file_name [String] File name  (REQUIRED)
  # @param file_handle [File] File handle (REQUIRED)
  # @param mime_type [String] Mime type
  # @return [Hash] Transient Document Response Body
  def self.create_transient_document(token, file_name, file_handle, mime_type=nil)
    headers = { :content_type => :json, :accept => :json, 'Access-Token' => token }

    begin
      response = RestClient.post( 
                                 ENDPOINT.fetch(:transientDocument), 
                                 { 'File-Name' => file_name, 
                                   'Mime-Type' => mime_type, 
                                   'File' => file_handle,  
                                   :multipart => true}, 
                                   headers
                                )
    rescue Exception => error
      raise_error(error)
    end

    JSON.parse(response.body)
  end

  # Gets all the users in an account that the caller has permissions to access. 
  #
  # @param token [String] Auth Token
  # @param user_email [String] The email address of the user whose details are being requested.
  # @return [Hash] User info hash
  def self.get_users(token, user_email)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:user)}?x-user-email=#{user_email}"
    response = get(endpoint, headers)
    JSON.parse(response)
  end

  # Gets all the users in an account that the caller has permissions to access. 
  #
  # @param token [String] Auth Token
  # @param user_id [String]
  # @return [Hash] User info hash
  def self.get_user(token, user_id)
    headers = { 'Access-Token' => token }
    endpoint = "#{ENDPOINT.fetch(:user)}/#{user_id}"
    response = get(endpoint, headers)
    JSON.parse(response)
  end


  private

  def self.get(endpoint, headers)
    RestClient.get(
      endpoint, 
      headers
    )
  end

  def self.post(endpoint, body, headers)
    RestClient.post(
      endpoint, 
      body.to_json, 
      headers
    )
  end

  def self.add_query(url, query)
    (url.include?('?') ? '&' : '?') + query
  end

  def self.raise_error(error)
    message = "#{error.inspect}.  \nSee Adobe Echosign REST API documentation for Error code meanings: https://secure.echosign.com/public/docs/restapi/v2"
    raise Failure.new message, error
  end

end

