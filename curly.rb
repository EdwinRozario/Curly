# frozen_string_literal: true
require 'addressable/uri'
require 'json'
require 'pry'
require 'bundler/setup'
Bundler.require

# Curly class
# Initialize with the domain name, fomart and any common parameter
# used in every api call like an api_key
class Curly
  attr_accessor :domain, :format, :constant_params, :pretty

  def initialize(domain, format, pretty = false, params)
    @domain = domain
    @format = format
    @constant_params = params
    @pretty = pretty
  end

  def get(path, params = {})
    complete_url = "'#{domain}/#{path}.#{format}?#{make_params(constant_params.merge(params))}'"
    response = call(complete_url)
    printer(method: 'GET', url: complete_url,
            response: response)
  end

  def post(path, data)
    complete_url = "-X POST -H 'Content-Type: application/json' -d '#{data.to_json}' '#{domain}/#{path}.#{format}?#{make_params(constant_params)}'"
    response = call(complete_url)
    printer(method: 'POST', url: complete_url,
            data: data.to_s, response: response)
  end

  def patch(path, data)
    complete_url = "-X PATCH -H 'Content-Type: application/json' -d '#{data.to_json}' '#{domain}/#{path}.#{format}?#{make_params(constant_params)}'"
    response = call(complete_url)
    printer(method: 'PATCH', url: complete_url,
            data: data.to_s, response: response)    
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

  def printer(method: nil, url: nil, data: nil, response: nil)
    table = Terminal::Table.new do |t|
      t << ['Method', method]
      t << :separator
      t.add_row ['Url', url]
      if data
        t.add_separator
        t.add_row ['Data', data]
      end
    end

    puts table
    puts '  Response'
    puts '-----------'
    puts pretty ? JSON.pretty_generate(response) : response
  end

  def call(data)
    response = `curl -s #{data}`
    JSON.parse(response)
  end
end


