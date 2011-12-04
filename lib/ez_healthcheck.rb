require "net/http"
require "rubygems"
require "aws-sdk"

class EzHealthcheck
  attr_accessor :codes, :host, :ses

  def initialize(host, id, key)
    @codes = {}
    @host = host
    @ses = AWS::SimpleEmailService.new(
      :access_key_id => id,
      :secret_access_key => key
    )
  end

  def access(paths=[])
    paths.each do |path|
      puts path
      response = Net::HTTP.get_response(@host,path)
      case response
      when Net::HTTPInformation
        #puts "1xx"
      when Net::HTTPSuccess
        #puts "2xx"
      when Net::HTTPRedirection
        #puts "3xx"
      when Net::HTTPClientError
        #puts "4xx"
      when Net::HTTPServerError
        #puts "5xx"
      else
        #puts "unknown"
      end
      @codes.store(path, response.code)
    end
  end

  def send_email(params={})
    begin
      @ses.send_email(
        :subject   => params[:subject],
        :from      => params[:from],
        :to        => params[:to],
        :body_text => params[:body_text],
        :body_html => params[:body_html]
      )
    rescue => ex
      puts ex
    end
  end

end
