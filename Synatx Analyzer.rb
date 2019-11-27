require_relative "Lexical Analyzer"
require_relative "Sentence Analyzer"

module Synatx_Analyzer
  $BE_array = Array.new
  $row = 0
  $temp_s ||= ""
  $variables = []
  @lines = 0
  @start = 1

  include Lexical_Analyzer
  include Sentence_Analyzer

  LA = Lexical_Analyzer
  SA = Sentence_Analyzer

  def lines
    @lines
  end

  def lines=(n)
    @lines = n
  end

  def main
    arrays = LA.main 
    
  def analyze_block(input_array)
    len = input_array.length
    array1 = input_array[0].split(%r[\s|\t])
    flag = false

    if array1[0] == "begin"
      flag = true
      array1.delete_at(0)
    else
      #error : lack 'begin'
      return "lines :#{@start} error : lack 'begin'"
    end

    array2 = input_array[len - 1].split(%r[\s|\t])
    len = array2.length

    if array2[len - 1] == "end"
      if flag
        flag = false
      else
        #error : lack 'begin'
        return "lines :#{@start} error : lack 'begin'"
      end
      array2.delete_at(len - 1)
    else
      if flag
        #error : lack 'end'
        return "lines :#{lines} error : lack 'end'"
      end
    end

    if array1.length > 0
      input_array[0] = array1
    else
      input_array.delete_at(0)
      @start += 1
    end

    if array2.length > 0
      input_array[input_array.length - 1] = array2
    else
      input_array.delete_at(input_array.length - 1)
      @lines -= 1
    end

    arrayp = SA.split_sentence(input_array)

    if arrayp.include?('error :')
      return arrayp.join(' ')
    end

    #puts arrayp.inspect

    #puts @lines.inspect

    variables = []
    arrayp.each do |each_sentence|
      result = SA.analyze_sentence(each_sentence, $variables)
      #puts result.inspect
      result.delete("success")
      if (result.include?("error :"))
        #error solve
        return "lines :#{@start} #{result.join(' ')} "
      end
      @start += 1
    end

    return "success"
  end
end

require "time"
require "thread"

#require_relative "Synatx Analyzer"

include Synatx_Analyzer

SA = Synatx_Analyzer

array = []
length =0

puts "please input the code block in next lines"
puts 

while true
  s = gets.chomp

  len = s.length

  length += 1
  if (s[len - 1] != "#")
    array << s
  else
    s.chop!
    array << s
    break
  end
end


SA.lines = length
puts SA.analyze_block(array)
