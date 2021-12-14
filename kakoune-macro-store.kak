
declare-option -hidden str-to-str-map macro_store

provide-module kakoune-macro-store %^

  define-command store-macro-at-interactive %{
    info -style modal "Enter a key to store current macro register at"

    on-key %|
      info -style modal

      lua %val{key} %reg{@} %{
        local key, current_macro = args()
        kak.set_option("-add", "global", "macro_store", string.format("%s=%s", key, string.gsub(current_macro, "=", "\\=")))
      }
    |
  }
  
  define-command play-macro-from-interactive %{
    info -style modal "Enter a key to play macro from"

    on-key %|
      info -style modal

      lua %val{key} %opt{macro_store} %{
        local args = args()
        local key = args[1]

        for ix = 2, #args do
          local first_eq_pos_begin, first_eq_pos_end = string.find(args[ix], "=")
          if first_eq_pos_begin ~= first_eq_pos_end then
            kak.fail("malformed map")
            return
          end
          local map_key = string.sub(args[ix],1 , first_eq_pos_begin - 1)
          if key == map_key then
            local raw_macro_body = string.sub(args[ix], first_eq_pos_begin + 1, #(args[ix]))
            local macro_body = string.gsub(raw_macro_body, "\\=", "=") 
            kak.execute_keys(macro_body)
            return
          end
        end
        kak.fail(string.format("key: %s not found in map: %s ", key, args))
        return
      }
    |
  }


^
