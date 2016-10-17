# Curly

Curly is a class that enables to make curl requests for GET and POST methods.

## Usage

```
curly = Curly.new('http://localhost:3000', true, :json, api_key: 'anApiKeey')
# initialise the object with the domain name, format and any parameter thats used with
# second param is to enable pretty print response. By defult this vale is false 
# all the url calls

curly.get('posts')
# This will make a GET call to 'http://localhost:3000/posts.json?api_key=anApiKeey'

curly.get('posts', { user: 'Yukava' })
# This will make a GET call to 'http://localhost:3000/posts.json?api_key=anApiKeey&user=Yukava'

curly.get('posts/126/comments')
# This will make a GET call to 'http://localhost:3000/posts/126/comments.json?api_key=anApiKeey'

curly.get('posts', { and: { category: 'Images' } })
# This will make a GET call to 'http://localhost:3000/posts.json?api_key=anApiKeey&and[category]=Image'

curly.post('posts', { name: 'Foo', description: 'Bar', tag: 'Quxx' })
# This will make a POST call to 'http://localhost:3000/posts.json?api_key=anApiKeey&name=Foo,description=Bar&tag=Quxx'
```

Note: More work to be done in future



