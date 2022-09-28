module YARD::MRuby::Handlers::C::Source
  class ModuleHandler < Base

    TOP_LEVEL_MODULE = /([\w]+)\s*=\s*mrb_define_module(?:_id)?\s*
      \(
      \s*\w+\s*,
      \s*("[\w_]+"|MRB_SYM\([\w_]+\))\s*
      \)
    /mx

    NAMESPACED_MODULE = /([\w]+)\s*=\s*mrb_define_module_under(?:_id)?\s*
      \(
      \s*\w+\s*,
      \s*([\w_\->]+|mrb_class_get(?:_id)?\([\w_]+\s*,\s*(?:"[\w_]+"|MRB_SYM\([\w_]+\))\))\s*,
      \s*("[\w_]+"|MRB_SYM\([\w_]+\))\s*
      \)
    /mx

    TOP_LEVEL_MODULE_GET = /([\w]+)\s*=\s*mrb_module_get(?:_id)?\s*
      \(
      \s*\w+\s*,
      \s*("[\w_]+"|MRB_SYM\([\w_]+\))\s*
      \)
    /mx

    handles TOP_LEVEL_MODULE
    handles NAMESPACED_MODULE
    handles TOP_LEVEL_MODULE_GET

    statement_class BodyStatement

    process do
      statement.source.scan(TOP_LEVEL_MODULE) do |var_name, module_name|
        handle_module(var_name, resolve_name(module_name), statement)
      end
      statement.source.scan(NAMESPACED_MODULE) do |var_name, in_module, module_name|
        handle_module(var_name, resolve_name(module_name), statement, resolve_name(in_module))
      end
      statement.source.scan(TOP_LEVEL_MODULE_GET) do |var_name, module_name|
        handle_module(var_name, resolve_name(module_name), statement)
      end
    end
  end
end

