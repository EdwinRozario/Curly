# frozen_string_literal: true
require 'addressable/uri'
require 'json'
require 'pry'

# Curly class
# Initialize with the domain name, fomart and any common parameter
# used in every api call like an api_key
class Curly
  attr_accessor :domain, :format, :constant_params

  def initialize(domain, format, params)
    @domain = domain
    @format = format
    @constant_params = params
  end

  def get(path, params = {})
    complete_url = "'#{domain}/#{path}.#{format}?#{make_params(constant_params.merge(params))}'"
    call(complete_url, 'GET')
  end

  def post(path, data)
    complete_url = "-X POST -H 'Content-Type: application/json' -d '#{data.to_json}' '#{domain}/#{path}.#{format}?#{make_params(constant_params)}'"
    call(complete_url, 'POST')
  end

  def patch(path, data)
    complete_url = "-X PATCH -H 'Content-Type: application/json' -d '#{data.to_json}' '#{domain}/#{path}.#{format}?#{make_params(constant_params)}'"
    call(complete_url, 'PATCH')
  end

  def make_params(params)
    nested_query = ''
    params.each do |param, value|
      if value.is_a? Hash
        params.delete(param)
        nested_query += "&#{param}\\[#{value.keys.first}\\]=#{value[value.keys.first]}"
      end
    end

    uri = Addressable::URI.new
    uri.query_values = params
    nested_query.empty? ? uri.query : "#{uri.query}#{nested_query}"
  end

  def call(data, method)
    response = `curl -s #{data}`
    puts "#{method}: #{data}"

    response_value = JSON.parse(response)
    puts "RESPONSE: #{response_value}"
    p '-------------------------------------------------------------------------------------------------------------------------'
    response_value
  end
end


