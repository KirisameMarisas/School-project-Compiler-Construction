

module Sentence_Analyzer
  require_relative "Lexical Analyzer.rb"
  include Lexical_Analyzer
  LA = Lexical_Analyzer

  @line = 0

  def error_load(result, error_message)
    result << "error :"
    result << error_message
    result.flatten!
    return result
  end

  def assignment_analyzer(array)
    #@pos = array.find_index(":=")

    #analyzer the right part

    count_left = 0
    flag_number = false

    result = []

    #puts array.inspect

    if (@pos == nil)
      result = error_load(result, "miss ':='")
      return result
    end

    for i in (@pos + 1)...array.length
      if (array[i] == ";")
        break 
      end

      #puts array[i].inspect

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

    if count_left > 0
      result = error_load(result, "miss ')'")
    end

    #puts result.inspect

    #result << "success"
    return result.flatten
  end

  def judge_express(array)
    sum_left = 0

    pos = 0

    #puts 
    #puts array.inspect

    for i in 0...array.length
      if (LA::WORDS.include?(array[i]))
        if (LA::WORDS[array[i]] >= 20 && LA::WORDS[array[i]] <= 24)
          pos = i
          break
        end
      end
    end

    result = []

    #puts array.inspect
    #puts pos 
    if (pos == 0)
      return  result = error_load(result,"worng symbol")
    end

    result_left = assignment_analyzer(array[1...pos])
    result_right = assignment_analyzer(array[pos + 1...(array.length - 1)])

    
    result << result_left << result_right

    #puts result.inspect

    return result
  end

  def if_sentence_analyzer(array)
    pos_if = array.find_index("if")
    pos_then = array.find_index("then")

    result = []

    #puts array.inspect

    if (pos_then != nil)
      result = judge_express(array[pos_if + 1...pos_then])
      result.delete([])
      if result.length == 0
        return []
      end
      #puts result.inspect
      return result
    else
      result = error_load(result, "miss then")
    end
  end

  def while_sentence_analyzer(array)
    #puts array.inspect
    return judge_express(array[1...array.length])
  end

  def analyze_block(input_array)
    flag = false

    #puts input_array.inspect

    message_array = []
    sum_begin = 0

    for i in 0...input_array.length
      @line += 1
      #puts sum_begin.inspect
      case input_array[i][0]
      when "begin"
        sum_begin += 1
        @flag_begin = true 
        #temp =  analyze_block(input_array[i + 1...(input_array.length - 1)])
        #puts temp.inspect
        #message_array << temp
      when "end"
        sum_begin -= 1
      else
        #puts input_array[i].inspect
        if (!@flag_begin)
          message_array << ["line #{@line - 1} : ", error_load([], "miss begin")].flatten
        end

        temp_array = analyze_sentence(input_array[i])
        #puts temp_array.inspect
        if (temp_array.length > 0 && !temp_array.include?("success"))
          message_array << ["line #{@line} :  #{temp_array}"].flatten
        end
        #puts message_array.inspect
      end
    end

    message_arrays = []
    message_array.each do |each_line|
      message_arrays << (each_line.is_a?(Array) ? each_line.join(" ") : each_line)
    end
    
    if (message_arrays.length == 0)
      message_arrays << "success"
    end


    #puts message_arrays.inspect

    return message_arrays
  end

  def analyze_expression(array)
    result = []
    case array[0]
    when "if"
      return if_sentence_analyzer(array)
    when "while"
      return while_sentence_analyzer(array)
    else
      @pos = array.find_index(":=")

      if (@pos != nil)
        return assignment_analyzer(array)
      else
        return result = error_load(result,"miss ':='")
      end

    end
  end

  def analyze_sentence(arrays)
    length = arrays.length
    line_status_array = []
    #for i in 0...length

    #puts arrays[i].inspect

    if arrays.length > 0
      result = analyze_expression(arrays)
      result.delete([])
    else
      return []
    end
    #puts result.inspect
    line_status_array << result
    #end
    return line_status_array.join(" ")
  end
end
