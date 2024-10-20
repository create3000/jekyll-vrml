# jekyll-vrml

Adds support for VRML syntax highlighting to Jekyll. This allows developers to easily integrate and display X3D content within their Jekyll-powered websites.

## Usage

Add the following lines to your Gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll-vrml', '~> 2.0', '>= 2.0.2'
end
```

After this, run `bundle install; bundle update`. Now you can highlight your source code in Markdown as VRML:

``````md
```vrml
#X3D V4.0 utf8

PROFILE Interchange

Transform {
  children Shape {
    appearance Appearance {
      material Material { }
    }
    geometry Box { }
  }
}
```
``````

## See Also

* [X_ITE X3D Browser](https://create3000.github.io/x_ite/)
* [web3d.org](https://www.web3d.org)
