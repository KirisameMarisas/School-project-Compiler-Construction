
require_relative "Lexical Analyzer.rb"

module Sentence_Analyzer
  include Lexical_Analyzer
  LA = Lexical_Analyzer

  $r_item = []
  $variables = []

  def split_sentence(input_array)
    input_array.flatten!
    array = []
    s = ""
    input_array.each do |each_line|
      each_line.strip!
      temp = each_line

      while temp.length > 0
        pos = temp.index(";")
        if pos != -1
          s = s + temp[0..pos]
          array << s
          temp = temp[pos + 1...temp.length]
          s = ""
        else
          s = temp
          break
        end
      end
    end
    if s.index(";") == -1
      #error : lack ;
      error_solve(["miss ';'"])
    end
    return array
  end

  def error_solve(error_array)
    $return_array << "error :"
    $return_array << error_array
    $return_array.flatten!
    return $return_array
  end

  def analyze_item(item)
    #puts item.inspect

    if $variables.include?(item)
      $return_array << "success"
      return $return_array
    else
      if LA::judge_digit(item[0])
        $return_array << "success"
        return $return_array
      else
        return error_solve(["input error", item])
      end
    end
  end

  def analyze_expression(expression)
    expression.strip!

    temp_stack = Array.new

    @temp_start = 0
    temp_expression = ""
    sign_flag = false

    expression = expression.split(" ")
    expression = expression.join("")
    temp_p = expression.index(%r[\+|\-|\*\/])
    if temp_p == nil
      return analyze_item(expression)
    end

    #puts expression.inspect

    for i in 0...expression.length
      if expression[i] == " "
        next
      end

      if expression[i] == "("
        temp_stack << expression[i]
        if i + 1 < expression.length
          @temp_start = i + 1
        else
          return error_solve(["sign error", "lack: ("])
        end

        next
      end

      if expression[i] == ")"
        if temp_stack.length > 0
          temp_stack.pop
        else
          return error_solve(["sign error", "lack: )"])
        end

        temp_expression = expression[@temp_start...i]
        #analyze_item
        temp_result = analyze_expression(temp_expression)
        if temp_result[0] != "success"
          return temp_result
        end

        next
      end

      if "+-*/".include?(expression[i])
        if sign_flag
          return error_solve(["sign error", expression[i]])
        end

        if temp_stack.length > 0
          next
        else
          temp_expression = expression[@temp_start...i]
          #analyze_item
          #puts "#{@temp_start} #{i}"
          temp_result = analyze_expression(temp_expression)
          if temp_result[0] != "success"
            return temp_result
          end
        end

        #puts "flag #{i}"
        sign_flag = true
        if i + 1 < expression.length
          @temp_start = i + 1
        else
          if i + 1 == expression.length
            return error_solve(["sign error", expression[i]])
          end
        end
        next
      end

      if (LA::judge_digit(expression[i]) || LA::judge_letter(expression[i]))
        sign_flag = false
      else
        return error_solve(["sign error", expression[i]])
      end
    end

    #puts @temp_start
    analyze_item(expression[@temp_start...expression.length])
    #puts $return_array.inspect
    if temp_stack.length > 0
      return error_solve(["sign error", "lack: )"])
    end

    return $return_array
  end

  def analze_s_sentence(s_sentence, variables, def_flag)
    s_sentence.strip!

    temp_pos = s_sentence.index(":=")
    if temp_pos == nil
      return error_solve("miss :=")
    else
      temp_variable = s_sentence[0...temp_pos]
    end

    temp_variable.strip!

    #puts temp_variable.inspect

    if def_flag
      variables << temp_variable
    else
      if !variables.include?(temp_variable)
        return error_solve(["undefined", temp_variable])
      end
    end

    #analze right
    temp_variable = s_sentence[temp_pos + 2...s_sentence.length]
    return analyze_expression(temp_variable)
  end

  def analyze_sentence(sentence, variables)
    $return_array = []
    $variables = variables
    if sentence[sentence.length - 1] != ";"
      return error_solve("miss ;")
    end
    sentence.chop!
    sentence = sentence.split(" ")
    def_flag = false
    def_type = ""

    #puts sentence.inspect

    #WORDS == nil
    if LA::WORDS[sentence[0]] != nil
      if LA::WORDS[sentence[0]] >= LA::WORDS["int"]
        def_flag = true
        def_type = sentence[0]
        sentence.delete_at(0)
      end
    end
    sentence = sentence.join(" ")
    #puts sentence.inspect
    return analze_s_sentence(sentence, variables, def_flag)
  end

  #analze_s_sentence

end
