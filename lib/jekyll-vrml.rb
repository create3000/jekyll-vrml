# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative "jekyll-vrml/version"
require "jekyll"

# This "hook" is executed right before the site"s pages are rendered
Jekyll::Hooks.register :site, :pre_render do |site|
  # puts "Adding VRML Markdown Lexer ..."
  require "rouge"

  # This class defines the VRML lexer which is used to highlight "vrml" code snippets during render-time
  class VRML < Rouge::RegexLexer
    title "VRML"
    desc "Classic VRML Encoding"

    tag "vrml"
    aliases "vrml", "x3dv", "wrl"
    filenames "*.x3dv", "*.wrl", "*.vrml"

    mimetypes "model/x3d+vrml", "model/vrml", "x-world/x-vrml"

    def self.detect?(text)
      return true if text =~ /\A#(?:X3D|VRML)\b/
    end

    start do
      @javascript = Rouge::Lexers::Javascript.new(options)
      @glsl = Rouge::Lexers::Glsl.new(options)
    end

    state :comments_and_whitespace do
      rule %r/[\x20\n,\t\r]+/, Text
      rule %r/#\/\*/, Comment::Multiline, :multilineComment
      rule %r/#.*?$/, Comment::Single
    end

    id = %r/[^\x30-\x39\x00-\x20\x22\x23\x27\x2b\x2c\x2d\x2e\x5b\x5c\x5d\x7b\x7d\x7f]{1}[^\x00-\x20\x22\x23\x27\x2c\x2e\x5b\x5c\x5d\x7b\x7d\x7f]*/

    state :root do
      rule %r/[,:.]/, Punctuation
      rule %r/[{}\[\]]/, Punctuation
      rule %r/\b(?:PROTO|EXTERNPROTO)\b/, Keyword, :typeName
      rule %r/\b(?:DEF|USE|ROUTE|TO|EXPORT|AS)\b/, Keyword, :name

      rule %r/\b(IMPORT)(\s*)(#{id})(\s*)(.)(\s*)(#{id})/ do
        groups Keyword, Text, Str::Regex, Text, Punctuation, Text, Str::Regex
      end

      mixin :comments_and_whitespace
      mixin :keywords
      mixin :accessTypes

      # https://github.com/rouge-ruby/rouge/blob/master/lib/rouge/lexers/javascript.rb

      rule %r/\b(?:TRUE|FALSE|NULL)\b/, Keyword::Constant
      rule %r/\b(?:SFBool|SFColor|SFColorRGBA|SFDouble|SFFloat|SFImage|SFInt32|SFMatrix3d|SFMatrix3f|SFMatrix4d|SFMatrix4f|VrmlMatrix|SFNode|SFRotation|SFString|SFTime|SFVec2d|SFVec2f|SFVec3d|SFVec3f|SFVec4d|SFVec4f|MFBool|MFColor|MFColorRGBA|MFDouble|MFFloat|MFImage|MFInt32|MFMatrix3d|MFMatrix3f|MFMatrix4d|MFMatrix4f|MFNode|MFRotation|MFString|MFTime|MFVec2d|MFVec2f|MFVec3d|MFVec3f|MFVec4d|MFVec4f)\b/, Keyword::Declaration

      rule %r/#{id}(?=\s*\{)/, Name::Class # typeNames
      rule %r/#{id}/, Name::Attribute # fieldNames

      rule %r/[+-]?(?:(?:(?:\d*\.\d+)|(?:\d+(?:\.)?))(?:[eE][+-]?\d+)?)/, Num::Float
      rule %r/(?:0[xX][\da-fA-F]+)|(?:[+-]?\d+)/, Num::Integer

      rule %r/"(?:(?:ecmascript|javascript|vrmlscript):|data:(?:text|application)\/javascript,)/ do
        token Str::Double
        @javascript.reset!
        push :ecmascript
      end

      rule %r/"data:x-shader\/(?:x-fragment|x-vertex),/ do
        token Str::Double
        @glsl.reset!
        push :glsl
      end

      rule %r/"/, Str::Delimiter, :dq
    end

    state :multilineComment do
      rule %r/[^*\/#]/, Comment::Multiline
      rule %r/\*\/#/, Comment::Multiline, :pop!
      rule %r/[*\/#]/, Comment::Multiline
    end

    state :keywords do
      rule %r/\b(?:PROFILE|COMPONENT|UNIT|META|DEF|USE|EXTERNPROTO|PROTO|IS|ROUTE|TO|IMPORT|EXPORT|AS)\b/, Keyword
    end

    state :accessTypes do
      rule %r/\b(?:initializeOnly|inputOnly|outputOnly|inputOutput|field|eventIn|eventOut|exposedField)\b/, Keyword
    end

    state :typeName do
      mixin :comments_and_whitespace
      rule %r/#{id}/, Name::Class, :pop!
    end

    state :name do
      mixin :comments_and_whitespace
      rule %r/#{id}/, Str::Regex, :pop!
    end

    state :dq do
      rule %r/\\[\\nrt"]?/, Str::Escape
      rule %r/[^\\"]+/, Str::Double
      rule %r/"/, Str::Delimiter, :pop!
    end

    state :ecmascript do
      # Avoid escaped double quotes string in dq strings.

      rule %r/\\[\\nrt"]?/, Str::Escape

      rule %r/[^\\"]+/ do
        delegate @javascript
      end

      rule %r/"/, Str::Delimiter, :pop!
    end

    state :glsl do
      # Avoid escaped double quotes string in dq strings.

      rule %r/\\[\\nrt"]?/, Str::Escape

      rule %r/[^\\"]+/ do
        delegate @glsl
      end

      rule %r/"/, Str::Delimiter, :pop!
    end

  end
end
