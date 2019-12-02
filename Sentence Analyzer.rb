


module Sentence_Analyzer
  require_relative "Lexical Analyzer.rb"
  include Lexical_Analyzer
  LA = Lexical_Analyzer

  def error_load(result, error_message)
    result << "error :"
    result << error_message
    result.flatten!
    return result
  end

  def analyze_expression(array)
    pos = array.find_index(":=")

    #analyzer the right part

    count_left = 0
    flag_number = false

    result = []

    if (pos == nil)
      result = error_load(result, "miss ':='")
      return result
    end

    for i in (pos + 1)...array.length
      if (array[i] == ";")
        break
      end

      if (array[i] == "(")
        if (flag_number)
          #error
          result = error_load(result, ["\'#{array[i]}\'", "wrong symbol"])
          return result
        end

        count_left += 1
        flag_number = false
        next
      end

      if (array[i] == ")")
        if (!flag_number)
          #error
          result = error_load(result, ["\'#{array[i]}\'", "wrong symbol"])
          return result
        end

        count_left -= 1
        if (count_left < 0)
          result = error_load(result, "miss '('")
          return result
        end

        flag_number = false
        next
      end

      if (LA::judge_digit(array[i]))
        flag_number = true
      else
        if (LA::judge_letter(array[i][0]))
          flag_number = true
        else
          if ("+-*/%".include?(array[i]))
            if (!flag_number)
              #error
              result = error_load(result, ["\'#{array[i]}\'", "wrong symbol"])
              return result 
            end

            flag_number = false
          else
            #error
            result = error_load(result, ["\'#{array[i]}\'", "wrong symbol"])
            return result
          end
        end
      end
    end

    result << "success"
    return result.flatten
  end

  def analyze_sentence(arrays)
    length = arrays.length
    line_status_array = []
    #for i in 0...length

    #puts arrays[i].inspect

    if arrays.length > 0
      result = analyze_expression(arrays)
    else
      return []
    end

    line_status_array << result
    #end
    return line_status_array.join(" ")
  end
end
