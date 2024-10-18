# jekyll-vrml

Adds support for VRML syntax highlighting to Jekyll.

## Usage

Add the following lines to your Gemfile:

```
group :jekyll_plugins do
  gem 'jekyll-vrml', '~> 2.0'
end
```

After this run `bundle install`. Now you can highlight your source code as VRML:

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
