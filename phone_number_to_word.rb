require 'date'

class PhoneNumberToWord

  attr_accessor :dictionary_words

  LETTERS_MAPPING = {"2" => ["a", "b", "c"],"3" => ["d", "e", "f"],"4" => ["g", "h", "i"],"5" => ["j", "k", "l"],"6" => ["m", "n", "o"],"7" => ["p", "q", "r", "s"],"8" => ["t", "u", "v"],"9" => ["w", "x", "y", "z"]}

  def initialize
    #read dictionary words
    @dictionary_words = {}
    collect_dictionary_words
  end

  def collect_dictionary_words
    file_path = "dictionary.txt"
    File.foreach( file_path ) do |word|
      dictionary_words[word.chop.to_s.length] = [] unless dictionary_words[word.chop.to_s.length]
      dictionary_words[word.chop.to_s.length] << word.chop.to_s.downcase
    end
  end

  def word_combinations(phone_number)
    time_start = Time.now()
    #return if number is not valid
    puts "#{phone_number}"
    msg = validate_phone_number(phone_number)
    return msg unless msg.empty? 
   
    digit_letters = phone_number.split('').map{|digit|LETTERS_MAPPING[digit]}

    results = {}
    total_numbers = digit_letters.length - 1 # total numbers
    #Loo through all letters and get matching records with dictionary
    (1..total_numbers - 1).each do |i|
      first_array = digit_letters[0..i]
      next if first_array.length < 3
      second_array = digit_letters[i + 1..total_numbers]
      next if second_array.length < 3
      first_combination = first_array.shift.product(*first_array).map(&:join)
      next if first_combination.nil?
      second_combination = second_array.shift.product(*second_array).map(&:join)
      next if second_combination.nil?
      results[i] = [(first_combination & dictionary_words[i+1]), (second_combination & dictionary_words[total_numbers - i])]
    end
    
    final_words = format_result(results, digit_letters)
    # for all numbers
    # time_end = Time.now()
    # puts "Time #{time_end.to_f - time_start.to_f}"
    final_words
  end

  def format_result(results, digit_letters)
    #arrange words like we need as a output
    final_words = []
    final_words << (digit_letters.shift.product(*digit_letters).map(&:join) & dictionary_words[10]).join(", ")
    results.each do |key, combinataions|
      next if combinataions.first.nil? || combinataions.last.nil?
      combinataions.first.product(combinataions.last).each do |combo_words|
        next if final_words.include?(combo_words.join(""))
        final_words << combo_words
      end
    end
    final_words
  end

  def validate_phone_number(phone_number)
    if phone_number.nil?
      "Number should not be blank"
    elsif phone_number.length != 10
      "Number length must be 10"
    elsif phone_number.include?('0')
      "Number should not include 0"
    elsif phone_number.include?('1')
      "Number should not include 1"
    else 
      ""  
    end
  end

end
puts "*********************************"
final_words = PhoneNumberToWord.new().word_combinations("6686787825")
print final_words
puts "\n*********************************"
final_words = PhoneNumberToWord.new().word_combinations("2282668687")
print final_words
puts "\n*********************************"
final_words = PhoneNumberToWord.new().word_combinations("22828687")
print final_words
puts "\n*********************************"
final_words = PhoneNumberToWord.new().word_combinations("2282660687")
print final_words
puts "\n*********************************"
final_words = PhoneNumberToWord.new().word_combinations("21182668687")
print final_words
puts "\n*********************************"
