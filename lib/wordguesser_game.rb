DEFAULT_MAXIMUM_WRONG_GUESSES = 7

class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_reader :word, :guesses, :wrong_guesses, :maximum_wrong_guesses

  def initialize(word, maximum_wrong_guesses = DEFAULT_MAXIMUM_WRONG_GUESSES)
    @word = word
    @solution = word.chars.uniq.sort
    @guesses = ''
    @wrong_guesses = ''
    @maximum_wrong_guesses = maximum_wrong_guesses
  end

  def guess(letter)
    raise ArgumentError, 'Expected a letter' unless WordGuesserGame.valid_guess?(letter)

    letter.downcase!
    played = @word.include?(letter) ? @guesses : @wrong_guesses
    played.include?(letter) ? false : played << letter
  end

  def word_with_guesses
    @word.gsub(/[^#{@guesses}*]/, '-')
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length >= @maximum_wrong_guesses

    return :win if @solution == @guesses.chars.sort

    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP
      .new('randomword.saasbook.info')
      .start { |http| return http.post(uri, '').body }
  end

  def self.valid_guess?(letter)
    /\p{L}/.match? letter
  end
end
