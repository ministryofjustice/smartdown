require 'parslet'

module Smartdown
  module Parser
    class NodeParser < Parslet::Parser

      rule(:eof) { any.absent? }
      rule(:ws_char) { match('\s')}
      rule(:space_char) { str(" ") }
      rule(:optional_space) { space_char.repeat }
      rule(:non_ws_char) { match('\S') }
      rule(:newline) { str("\r\n") | str("\n\r") | str("\n") | str("\r") }

      rule(:ws) { ws_char.repeat }
      rule(:non_ws) { non_ws.repeat }

      rule(:whitespace_terminated_string) {
        non_ws_char >> (non_ws_char | space_char >> non_ws_char).repeat
      }

      rule(:identifier) {
        match('[a-zA-Z_0-9-]').repeat(1)
      }
      rule(:front_matter) {
        identifier.as(:name) >> str(":") >> ws >> whitespace_terminated_string.as(:value) >> newline
      }
      rule(:blank_line) {
        newline >> newline
      }
      rule(:markdown_line) {
        optional_space >> whitespace_terminated_string >> optional_space
      }
      rule(:bullet) {
        match('[*-]')
      }
      rule(:option_definition_line) {
        bullet >>
          optional_space >>
          identifier.as(:value) >>
          str(":") >>
          optional_space >>
          whitespace_terminated_string.as(:label) >>
          optional_space
      }

      rule(:multiple_choice_paragraph) {
        (option_definition_line >> (eof | newline)).repeat(1).as(:multiple_choice)
      }

      rule(:markdown_paragraph) {
        (markdown_line >> (eof | newline)).repeat(1).as(:p)
      }

      rule(:markdown_heading) {
        str('# ') >> (whitespace_terminated_string >> optional_space >> (eof | newline)).as(:h1)
      }

      rule(:markdown_block) {
        markdown_heading | multiple_choice_paragraph | markdown_paragraph
      }

      rule(:markdown_paragraphs) {
        markdown_block >> (newline >> markdown_block).repeat
      }

      rule(:body) {
        markdown_paragraphs.as(:body)
      }

      rule(:flow) {
        front_matter.repeat.as(:front_matter) >> newline >> body |
        front_matter.repeat.as(:front_matter) |
        body
      }

      root(:flow)
    end
  end
end
