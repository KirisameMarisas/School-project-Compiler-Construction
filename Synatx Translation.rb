


module Synatx_Translation

  require_relative "Lexical Analyzer"
  include Lexical_Analyzer

  LA = Lexical_Analyzer

  def block_sentence(arrays)
    arrays.each do |each_line|
      if (each_line.length > 0)
        #translation this sentence
      end
    end
  end

  def infix_to_suffix(sentence_array)
    stack_sop = []
    stack_L = []

    #puts sentence_array.inspect

    for i in 0...sentence_array.length
      #puts sentence_array[i].inspect

      if (sentence_array[i] == ";")
        break
      end

      if (sentence_array[i] == "(")
        stack_sop.push(sentence_array[i])
        next
      end

      if (sentence_array[i] == ")")
        while ((temp = stack_sop.pop) != "(")
          stack_L.push(temp)
        end

        next
      end

      if (LA::judge_digit(sentence_array[i]))
        stack_L.push(sentence_array[i])
        next
      end

      if (stack_sop.length == 0 || stack_sop.last == "(")
        stack_sop.push(sentence_array[i])
        next
      end

      if ("*/%".include?(sentence_array[i]))
        stack_sop.push(sentence_array[i])
      else
        #puts sentence_array[i].inspect

        temp_stack = []
        while (stack_sop.length > 0) && ("*/".include?(stack_sop.last))
          temp_stack.push(stack_sop.pop)
        end
        
        while (temp_stack.length > 0)
            stack_L.push(temp_stack.pop)
        end

        stack_sop.push(sentence_array[i])
      end
    end

    while (stack_sop.length > 0)
      stack_L.push(stack_sop.pop)
    end

    return stack_L
  end

  def sentence_translation(sentence_array)
    pos = sentence_array.find_index(":=")

    #puts sentence_array.inspect

    stack_sop = []
    stack_L = infix_to_suffix(sentence_array[(pos + 1)..sentence_array.length])

    #puts stack_L.inspect

    stack_sop.clear

    num = 0

    for i in 0...stack_L.length
      if (!LA::judge_digit(stack_L[i]))
        x1 = stack_sop.pop
        x2 = stack_sop.pop

        puts "t#{(num += 1).to_s} = #{x2} #{stack_L[i]} #{x1}"

        stack_sop.push("t#{num.to_s}")
      else
        stack_sop.push(stack_L[i])
      end
    end

    #puts stack_sop.inspect

    puts "#{sentence_array[0]} = #{stack_sop[0]}"
  end
end
