module YARD::MRuby::Handlers::C::Source
  class CommentHandler < Base
    include YARD::Parser::C::CommentParser

    statement_class Comment
    handles /./

    process do
      statement.overrides.each do |type, name|
        case type
        when :method
          statement.source = parse_callseq(statement.source.sub(/\A\s*(?=call-seq:)/m, "").split("\n")).join("\n")
        end
        override_comments << [name, statement]
      end
    end
  end
end
