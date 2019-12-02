

module Synatx_Analyzer
  require_relative "Lexical Analyzer"
  require_relative "Sentence Analyzer"
  require_relative "Synatx Translation"
  
  include Lexical_Analyzer
  include Sentence_Analyzer
  include Synatx_Translation

  LA = Lexical_Analyzer
  SA = Sentence_Analyzer
  ST = Synatx_Translation

  @error_flag = false

  def mainSyA
    arrays = LA.main
    delete_end_symbol(arrays)

    #puts arrays.inspect
    #puts arrays.length .inspect

    puts
    analyze_block(arrays)

    #puts arrays.inspect

    #puts @error_flag.inspect
    #=begin
    puts
    if (!@error_flag)
      for i in 0...arrays.length
        if (arrays[i].length > 0)
          ST::sentence_translation(arrays[i])
          puts
        end
      end
    end

    #=end
  end

  def message_solve(message_array)
    message_arrays = []
    message_array.each do |each_line|
      message_arrays << each_line.join(" ")
    end

    return message_arrays
  end

  def merge(preview_array, message_array)
    #puts preview_array.inspect
    for i in 0...preview_array.length
      message_array << preview_array[i]
    end

    return message_array
  end

  def delete_end_symbol(arrays)
    array_length = arrays.length

    for i in (array_length - 1).downto(0)
      line_length = arrays[i].length
      for j in (line_length - 1).downto(0)
        if (arrays[i][j] == "#")
          arrays[i].delete_at(j)
          return
        end
      end
    end
  end

  def analyze_block(input_array)
    flag = false

    temp_array = []
    message_array = []
    num_begin = 0

    i = 0
    input_array.each do |each_line|
      i += 1
      if (each_line[0] == "begin")
        flag = true
        num_begin += 1
        each_line.delete("begin")
        next
      end

      if (each_line[0] == "end")

        #error miss 'begin'
        each_line.delete("end")
        if (num_begin <= 0)
          temp_array << ["line #{i} : ", SA.error_load([], "miss begin")].flatten
        else
          num_begin -= 1
        end
        next
      end

      tempelete_array = SA.analyze_sentence(each_line)
      if (tempelete_array.length > 0 && !tempelete_array.include?("success"))
        message_array << ["line #{i} :  #{tempelete_array}"].flatten
      end
      #puts message_array.inspect
    end
    if (num_begin > 0)
      temp_array << ["line #{input_array.length} : ", SA.error_load([], "miss end")].flatten
    end
    if (!flag)
      #error miss 'begin'
      temp_array << ["line 1 : ", SA.error_load([], "miss begin")].flatten
    end

    #puts temp_array.inspect

    message_array = merge(temp_array, message_array)

    #puts message_array.inspect

    message_array = message_solve(message_array)

    if (message_array.length>0)
      @error_flag = true
      message_array.delete("success")
    else
      message_array.delete("success")
      message_array << "success"
    end

    puts message_array
  end
end

include Synatx_Analyzer

SyA = Synatx_Analyzer

SyA.mainSyA
