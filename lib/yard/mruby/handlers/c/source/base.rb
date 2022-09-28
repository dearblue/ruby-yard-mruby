module YARD::MRuby::Handlers
  module C
    module Source
      class Base < YARD::Handlers::C::Base

        DEFAULT_NAMESPACES = {
          # 'mrb->top_self'      => '',
          'object_class'  => 'Object',
          'class_class'   => 'Class',
          'module_class'  => 'Module',
          'proc_class'    => 'Proc',
          'string_class'  => 'String',
          'array_class'   => 'Array',
          'hash_class'    => 'Hash',
          'float_class'   => 'Float',
          'fixnum_class'  => 'Fixnum',  # cases prior to 3.0.0
          'integer_class' => 'Integer', # cases after 3.0.0
          'true_class'    => 'TrueClass',
          'false_class'   => 'FalseClass',
          'nil_class'     => 'NilClass',
          'symbol_class'  => 'Symbol',
          'range_class'   => 'Range',
          'kernel_module' => 'Kernel',
          'eException_class' => 'Exception',
          'eStandardError_class' => 'StandardError'
        }

        OPSYM_LOOKUP = {
          "add" => "+",     "and" => "&",   "andand" => "&&", "aref" => "[]",
          "aset" => "[]=",  "cmp" => "<=>", "div" => "/",     "eq" => "==",
          "eqq" => "===",   "ge" => ">=",   "gt" => ">",      "le" => "<=",
          "lshift" => "<<", "lt" => "<",    "match" => "=~",  "minus" => "-@",
          "mod" => "%",     "mul" => "*",   "neg" => "~",     "neq" => "!=",
          "nmatch" => "!~", "not" => "!",   "or" => "|",      "oror" => "||",
          "plus" => "+@",   "pow" => "**",  "rshift" => ">>", "sub" => "-",
          "tick" => "`",    "xor" => "^",
        }

        def resolve_name(name)
          case name
          when /MRB_SYM\(([\w_]+)\)/, /"([^"]+)"/; return $1
          when /MRB_CVSYM\(([\w_]+)\)/; return "@@#$1"
          when /MRB_IVSYM\(([\w_]+)\)/; return "@#$1"
          when /MRB_SYM_B\(([\w_]+)\)/; return "#$1!"
          when /MRB_SYM_E\(([\w_]+)\)/; return "#$1="
          when /MRB_SYM_Q\(([\w_]+)\)/; return "#$1?"
          when /MRB_OPSYM\(([\w_]+)\)/; return OPSYM_LOOKUP[$1] || name
          when /^\w+->(\w+_(?:class|module))$/; return DEFAULT_NAMESPACES[$1] || name
          else;                         return name
          end
        end

        def resolve_boot_name(name)
          case name
          when "0";   return nil
          when "bob"; return "BasicObject"
          when "obj"; return "Object"
          when "mod"; return "Module"
          when "cls"; return "Class"
          end
        end

        def handle_class(var_name, class_name, parent, stmt, in_module = nil)
          object = super(var_name, class_name, parent, in_module)

          if stmt.comments
            register_docstring(object, stmt.comments.source, stmt)
          end

          object
        end

        def handle_module(var_name, module_name, stmt, in_module = nil)
          object = super(var_name, module_name, in_module)

          if stmt.comments
            register_docstring(object, stmt.comments.source, stmt)
          end

          object
        end

      end

    end

    YARD::Handlers::Processor.register_handler_namespace :source, Source
  end
end
