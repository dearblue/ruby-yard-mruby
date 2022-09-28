module YARD::MRuby::Handlers::C::Source
  class MethodHandler < Base
    MATCH1 = /mrb_define_(
        method |
        class_method |
        singleton_method |
        module_function
      ) (?:_id)?
      \s*\(
      \s*\w+\s*,
      \s*([\w_\->]+)\s*,
      \s*("[^"]+"|MRB_(?:CVSYM|IVSYM|OP_SYM|SYM|SYM_B|SYM_E|SYM_Q)\([\w_]+\))\s*,
      \s*([\w_]+)\s*,
    /mx

    handles MATCH1
    statement_class BodyStatement

    process do
      statement.source.scan(MATCH1) do |type,var_name, name, func_name|
        type = "singleton_method" if type == "class_method"
        handle_method(type, resolve_name(var_name), resolve_name(name), func_name)
      end
    end

  end
end
