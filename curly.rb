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
    uri = Addressable::URI.new
    uri.query_values = params
    uri.query
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

curly = Curly.new('http://localhost:3000', :json, api_key: 'RYAVDhaqNsCyyYtssLFE')

# TEST CALLS
# curly.get('records')
curly.get('stories')
# {"name"=>"New Story", "description"=>"", "privacy"=>"public", "featured"=>false, "approved"=>false, "tags"=>[], "id"=>"57fd697769ae851c55000000", "number_of_items"=>0, "contents"=>[]}
curly.get('stories/57fd697769ae851c55000000')
curly.get('stories/57fd697769ae851c55000000/story_items')
curly.get('stories/57fd697769ae851c55000000/story_items/57fd885169ae851eed000000')
curly.post('stories', { name: 'New Story For Test'})
curly.post('stories/57fd697769ae851c55000000/story_items', {})
curly.post('stories/57fd697769ae851c55000000/story_items', { block: {}})
curly.post('stories/57fd697769ae851c55000000/story_items',
           { block: { type: 'texting', sub_type: 'header' } })

curly.post('stories/57fd697769ae851c55000000/story_items',
           { block: { type: 'text', sub_type: 'heading' } })

curly.post('stories/57fd697769ae851c55000000/story_items',
           { block: { type: 'text', sub_type: 'heading',
                          content: {}, meta: {} } })

curly.post('stories/57fd697769ae851c55000000/story_items',
           { block: { type: 'text', sub_type: 'heading',
                          content: { value: 'Value text here' },
                          meta: {} } })

curly.patch('stories/57fd697769ae851c55000000/story_items/57fd885169ae851eed000000', {
  item: { type: 'text', sub_type: 'heading',
                          content: { value: 'Updated Text Again' },
                          meta: {} }
  })

# curly.get('stories/57fd697769ae851c55000000/story_items/57fd885169ae851eed000000')






