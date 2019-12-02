module Lexical_Analyzer
  $flag = false
  WORDS = { "begin" => 1, "if" => 2, "then" => 3, "while" => 4, "do" => 5, "end" => 6, "letter*" => 10, "digit*" => 11, "+" => 13, "-" => 14, "*" => 15, "/" => 16, ":" => 17, ":=" => 18, "<" => 20, "<>" => 21, "<=" => 22, ">" => 23, ">=" => 24, "=" => 25, ";" => 26, "(" => 27, ")" => 28, "#" => 0, "int" => 31, "double" => 32 }

  @@arrays = Array.new

  def judge_digit(word)
    return /\A[-+]?\d+\z/.match(word.to_s)
  end

  def judge_letter(input_word)
    #puts word
    word = input_word[0]

    if (word >= "a" && word <= "z")
      return true
    end
    if (word >= "A" && word <= "Z")
      return true
    end
    return false
  end

  def word_analyze(word)
    temp_word = ""
    temp_symbol = ""
    word.each_char do |element|
      if (element == ";")
        break
      end

      if ($flag)
        return
      end
      #puts element.inspect
      if (judge_digit(element) || judge_letter(element))
        temp_word += element
        if (temp_symbol != "")
          #output(temp_symbol)
          @@arrays << temp_symbol
        end
        temp_symbol = ""
      else
        if WORDS.include?(element)
          
          if (temp_word[0] != nil)
            @@arrays << temp_word
          end

          if ("+-*/%".include?(element))
            @@arrays << element
          else 
            temp_symbol += element
          end

          temp_word = ""
        end
      end
    end
    if (temp_word != "")
      @@arrays << temp_word
    end
    if (temp_symbol != "")
      #output(temp_symbol)
      @@arrays << temp_symbol
    end

    @@arrays << ";"
  end

  def output(arrays)
    temp_array = arrays.flatten
    temp_array.each do |element|
      if WORDS.include?(element)
        print "(#{WORDS[element]},#{element}) "
      else
        if judge_digit(element)
          print "(#{WORDS["digit*"]},#{element}) "
        else
          print "(#{WORDS["letter*"]},#{element}) "
        end
      end
    end
    puts
  end

  def main
    puts "Input a cod block with \'#\' end of this block"
    total_arrays ||= Array.new
    while true
      s = gets.chomp
      string_s = s.split(" ")

      string_s.each do |word|
        if ($flag)
          return
        end

        if WORDS.include?(word)
          #output(word)
          @@arrays << word
        else
          word_analyze(word)
        end
      end
      total_arrays << Marshal.load(Marshal.dump(@@arrays))
      @@arrays.clear
      if (string_s[string_s.length - 1] == "#")
        break
      end
    end
    return total_arrays
  end
end

=begin
include Lexical_Analyzer
LA = Lexical_Analyzer

LA.output(LA.main)

=end
