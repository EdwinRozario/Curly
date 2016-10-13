# Curly

Curly is a class that enables to make curl requests for GET and POST methods.

## Usage

```
curly = Curly.new('http://localhost:3000', :json, api_key: 'RYAVDhaqNsCyyYtssLFE')
# initialise the object with the domain name, fomat and any parameter thats used with 
# all the url calls

curly.get('posts')
# This will make a GET call to 'http://localhost:3000/posts.json?api_key=RYAVDhaqNsCyyYtssLFE'

curly.get('posts', { user: 'Yukava' })
# This will make a GET call to 'http://localhost:3000/posts.json?api_key=RYAVDhaqNsCyyYtssLFE&user=Yukava'

curly.get('posts/126/comments')
# This will make a GET call to 'http://localhost:3000/posts/126/comments.json?api_key=RYAVDhaqNsCyyYtssLFE'

curly.get('posts', { and: { category: 'Images' } })
# This will make a GET call to 'http://localhost:3000/posts.json?api_key=RYAVDhaqNsCyyYtssLFE&and[category]=Image'

curly.post('posts', { name: 'Foo', description: 'Bar', tag: 'Quxx' })
# This will make a POST call to 'http://localhost:3000/posts.json?api_key=RYAVDhaqNsCyyYtssLFE&name=Foo,description=Bar&tag=Quxx'
```



