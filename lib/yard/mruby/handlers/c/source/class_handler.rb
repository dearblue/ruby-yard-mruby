module YARD::MRuby::Handlers::C::Source
  class ClassHandler < Base

    TOP_LEVEL_CLASS = /([\w_]+)\s*=\s*mrb_define_class(?:_id)?\s*
      \(
      \s*\w+\s*,
      \s*("[\w_]+"|MRB_SYM\([\w_]+\))\s*,
      \s*([\w_\->]+|mrb_class_get(?:_id)?\([\w_]+\s*,\s*(?:"[\w_]+"|MRB_SYM\([\w_]+\))\))\s*
      \)
    /mx

    NAMESPACED_CLASS = /([\w_]+)\s*=\s*mrb_define_class_under(?:_id)?\s*
      \(
      \s*\w+\s*,
      \s*([\w_\->]+|mrb_class_get(?:_id)?\([\w_]+\s*,\s*(?:"[\w_]+"|MRB_SYM\([\w_]+\))\))\s*,
      \s*("[\w_]+"|MRB_SYM\([\w_]+\))\s*,
      \s*([\w_\->]+|mrb_class_get(?:_id)?\([\w_]+\s*,\s*(?:"[\w_]+"|MRB_SYM\([\w_]+\))\))\s*
      \)
    /mx

    TOP_LEVEL_CLASS_GET = /([\w_]+)\s*=\s*mrb_class_get(?:_id)?\s*
      \(
      \s*\w+\s*,
      \s*("[\w_]+"|MRB_SYM\([\w_]+\))\s*
      \)
    /mx

    BOOT_CLASS = /([\w_]+)\s*=\s*boot_defclass\s*
      \(
      \s*\w+\s*,
      \s*([\w_]+)\s*
      \)
    /mx

    ROOT_CLASS = /^([\w_]+)\s*=\s*mrb->([\w_]+_class);/m

    handles TOP_LEVEL_CLASS
    handles NAMESPACED_CLASS
    handles TOP_LEVEL_CLASS_GET
    handles BOOT_CLASS
    handles ROOT_CLASS

    statement_class BodyStatement

    process do
      statement.source.scan(TOP_LEVEL_CLASS) do |var_name, class_name, parent|
        handle_class(var_name, resolve_name(class_name), resolve_name(parent), statement)
      end
      statement.source.scan(NAMESPACED_CLASS) do |var_name, in_module, class_name, parent|
        handle_class(var_name, resolve_name(class_name), resolve_name(parent), statement, resolve_name(in_module))
      end
      statement.source.scan(TOP_LEVEL_CLASS_GET) do |var_name, class_name|
        handle_class(var_name, resolve_name(class_name), nil, statement)
      end
      statement.source.scan(BOOT_CLASS) do |var_name, parent|
        class_name = resolve_boot_name(var_name)
        parent = resolve_boot_name(parent)
        handle_class(var_name, class_name, parent, statement)
      end
      statement.source.scan(ROOT_CLASS) do |var_name, class_name|
        handle_class(var_name, DEFAULT_NAMESPACES[class_name], nil, statement)
      end
    end
  end
end
