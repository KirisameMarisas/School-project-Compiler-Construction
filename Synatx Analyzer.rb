require_relative "Lexical Analyzer"
require_relative "Sentence Analyzer"

module Synatx_Analyzer
  include Lexical_Analyzer
  include Sentence_Analyzer

  LA = Lexical_Analyzer
  SA = Sentence_Analyzer

  def mainSyA
    arrays = LA.main
    delete_end_symbol(arrays)

    #puts arrays.inspect 
    #puts arrays.length .inspect

    analyze_block(arrays)
  end

  def message_solve(message_array)
    message_arrays = []
    message_array.each do |each_line|
      message_arrays << each_line.join(" ")
    end

    return message_arrays
  end

  def get_last_element(array)
    last_line = array.length

    while true
      if (array[last_line - 1].length > 0)
        temp_line = array[last_line - 1]
        return [last_line - 1, temp_line.length - 1]
      else
        last_line -= 1
        if (last_line < 0)
          return nil
        end
      end
    end
  end
  
  def merge(preview_array,message_array)
    for i in 0...preview_array.length do

      message_array.insert(i,preview_array[i])
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

    input_array.each do |each_line|
      for i in 0...each_line.length
        if (each_line[i] == "begin")
          flag = true
          last_element = get_last_element(input_array)

          if (input_array[last_element[0]][last_element[1]] == "end")
            input_array[last_element[0]].delete_at(last_element[1])
          else
            #error miss 'end'
            temp_array << ["line #{last_element[0] + 1} : ",SA.error_load([],"miss end")]
          end

          each_line.delete_at(i)
        else
          break
        end

        if (each_line[i] == "end")

          #error miss 'begin'
          temp_array << ["line #{i} : ",SA.error_load([],"miss begin")]
        end
      end
    end

    if (!flag)
      #error miss 'begin'
      temp_array << ["line 1 : ",SA.error_load([],"miss begin")]
    end
    message_array = SA.analyze_sentence(input_array)
    message_array = merge(temp_array,message_array)
    message_array = message_solve(message_array)
    puts message_array
  end
end

include Synatx_Analyzer

SyA = Synatx_Analyzer

SyA.mainSyA
