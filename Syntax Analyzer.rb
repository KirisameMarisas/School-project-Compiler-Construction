

module Syntax_Analyzer
  require_relative "Lexical Analyzer"
  require_relative "Sentence Analyzer"
  require_relative "Syntax Translation"

  include Lexical_Analyzer
  include Sentence_Analyzer
  include Syntax_Translation

  LA = Lexical_Analyzer
  SA = Sentence_Analyzer
  ST = Syntax_Translation

  @error_flag = false

  def mainSyA
    arrays = LA.main
    delete_end_symbol(arrays)


    puts

    temp = SA.analyze_block(arrays)

    puts temp

    if (temp[0] != "success")
      @error_flag = true
    end

    translation_array = []
    if_while_array = []

    flag_if_while = []

    puts
    if (!@error_flag)
      for i in 0...arrays.length
        if (arrays[i].length > 0)
          case arrays[i][0]
          when "begin"
            #flag_if_while += 1
            #next
          when "end"
            #flag_if_while -= 1
             
            if (if_while_array.length > 0)
              x = flag_if_while.pop

              pos_line = ST::line

              len = flag_if_while.length
              point = 0

              for l in 0...if_while_array.length do 
                if (if_while_array[l][0].include?("if"))
                  if (len == 0)
                    point = l
                    break
                  end
                  len -= 1
                end
              end

              if (x[0] == "if")
                #puts if_while_array.inspect
                #puts pos_line
                if_while_array[l][1] += (pos_line + 1).to_s
                if_while_array << "line #{pos_line + 1} :   "
                ST::line = pos_line += 1
                #if_while_array.last.last += pos_line().to_s
                #puts if_while_array

              end

              if (x[0] == "while")
                #puts if_while_array.inspect
                if_while_array[l][1] += (pos_line + 2).to_s
                if_while_array << "line #{pos_line + 1} :  goto #{ST::while_line}"
                #puts pos_line
                ST::line = pos_line += 1
                if_while_array << "line #{pos_line + 1} :   "
                #puts if_while_array
              end

              #if_while_array.clear
              #puts if_while_array.inspect

              if (flag_if_while.length == 0)
                if_while_array.uniq!
                puts
                puts if_while_array
                #puts if_while_array.inspect
                if_while_array.clear
              end
            end

            #next
          else
            translation_array = ST::sentence_translation(Marshal.load(Marshal.dump(arrays[i]))).flatten

            if (arrays[i][0] == "if" || arrays[i][0] == "while")
              flag_if_while.push([arrays[i][0], i + 1])
            end

            if (flag_if_while.length > 0)
              if_while_array << translation_array
            else
              if (if_while_array.length > 0)
                translation_array = if_while_array
              end
              puts
              puts translation_array
            end
          end
        end
      end
    end

    #=end
  end
  
  def delete_end_symbol(arrays)
    array_length = arrays.length

    for i in (array_length - 1).downto(0)
      line_length = arrays[i].length
      for j in (line_length - 1).downto(0)
        if (arrays[i][j] == "#")
          arrays[i].delete_at(j)
          arrays.delete([])
          return
        end
      end
    end
  end

end

include Syntax_Analyzer

SyA = Syntax_Analyzer

SyA.mainSyA
