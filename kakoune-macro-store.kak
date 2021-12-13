
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
        local key, macro_store_string_map = args()
        for pair in string.gmatch(macro_store_string_map, "%S+") do
          local first_eq_pos_begin, first_eq_pos_end = string.find(pair, "=")
          if first_eq_pos_begin ~= first_eq_pos_end then
            kak.fail("malformed map")
            return
          end
          local map_key = string.sub(pair,1 , first_eq_pos_begin - 1)
          if key == map_key then
            local raw_macro_body = string.sub(pair, first_eq_pos_begin + 1, #pair)
            local macro_body = string.gsub(raw_macro_body, "\\=", "=") 
            kak.execute_keys(macro_body)
            return
          end
        end
        kak.fail("key not found")
        return
      }
    |
  }
^
