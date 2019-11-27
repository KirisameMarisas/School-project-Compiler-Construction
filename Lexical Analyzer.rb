module Lexical_Analyzer
  $flag = false
  WORDS = { "begin" => 1, "if" => 2, "then" => 3, "while" => 4, "do" => 5, "end" => 6, "letter*" => 10, "digit*" => 11, "+" => 13, "-" => 14, "*" => 15, "/" => 16, ":" => 17, ":=" => 18, "<" => 20, "<>" => 21, "<=" => 22, ">" => 23, ">=" => 24, "=" => 25, ";" => 26, "(" => 27, ")" => 28, "#" => 0, "int" => 31, "double" => 32 }

  @arrays = Array.new

  def output(word)
    print "(#{WORDS[word]},#{word}) "
  end

  def output_lOn(flag, word)
    print "(#{WORDS[flag]},#{word}) "
  end

  def judge_digit(word)
    return /\A[-+]?\d+\z/.match(word.to_s)
  end

  def judge_letter(word)
    #puts word

    if (word >= "a" && word <= "z")
      return true
    end
    if (word >= "A" && word <= "Z")
      return true
    end
    return false
  end

  def output_word(temp_word)
    if (temp_word != "")
      if (judge_letter(temp_word[0]))
        #output_lOn("letter*", temp_word)
      else
        #output_lOn("digit*", temp_word)
      end
    end
  end

  def output_digit(temp_word)
    if (temp_word != "")
      temp_word.each_char do |element|
        if (judge_letter(element))
          $flag = true
          puts "error"
          return
        end
      end
    end
    #output_lOn("digit*", temp_word)
  end

  def word_analyze(word)
    temp_word = ""
    temp_symbol = ""
    word.each_char do |element|
      if ($flag)
        return
      end
      #puts element.inspect
      if (judge_digit(element) || judge_letter(element))
        temp_word += element
        if (temp_symbol != "")
          #output(temp_symbol)
          @arrays << temp_symbol
        end
        temp_symbol = ""
      else
        if WORDS.include?(element)
          temp_symbol += element
          if (temp_word[0] != nil)
            if (judge_letter(temp_word[0]))
              #output_word(temp_word)
            else
              #output_digit(temp_word)
            end
            @arrays << temp_word
          end
          temp_word = ""
        end
      end
    end
    if (temp_word != "")
      if (judge_letter(temp_word[0]))
        #output_word(temp_word)
      else
        #output_digit(temp_word)
      end
      @arrays << temp_word
    end
    if (temp_symbol != "")
      #output(temp_symbol)
      @arrays << temp_symbol
    end
  end

  def output
    @arrays.each do |element|
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
    puts "Input a cod block with \'end\' end of this block"
    while true
      s = gets.chomp
      string_s = s.split(" ")
      string_s.each do |word|
        if ($flag)
          return
        end

        if WORDS.include?(word)
          #output(word)
          @arrays << word
        else
          word_analyze(word)
        end
      end
      #puts
      if (string_s[string_s.length - 1] == "#")
        break
      end
    end
    output
    puts @arrays.inspect
  end
end

=begin
include Lexical_Analyzer
LA = Lexical_Analyzer

LA.main
=end
