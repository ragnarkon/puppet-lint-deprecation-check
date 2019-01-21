# Checks the manifest for legacy Hiera 3 functions.
#
# @see https://puppet.com/docs/puppet/5.2/hiera_use_hiera_functions.html
PuppetLint.new_check(:hiera_function) do
  def check
    function_tokens = tokens.select { |token| token.type == :FUNCTION_NAME }

    function_tokens.each do |token|
      if token.value.match(%r{^hiera(|_array|_hash|_include)$})
        notify(
          :warning,
          :message => "#{token.value} function has been deprecated",
          :line    => token.line,
          :column  => token.column,
          :token   => token
        )
      end
    end
  end

  # Attempts to fix the problem based on recommendations from Puppet.
  #
  # https://puppet.com/docs/puppet/5.2/hiera_use_hiera_functions.html
  def fix(problem)
    unless problem[:token].value == 'hiera'
      merge_value = case problem[:token].value
                    when 'hiera_array', 'hiera_include'
                      'unique'
                    when 'hiera_hash'
                      'hash'
                    end

      index = next_token_index_of(:RPAREN, problem[:token])
      [
        PuppetLint::Lexer::Token.new(:COMMA,',',0,0),
        PuppetLint::Lexer::Token.new(:WHITESPACE,' ',0,0),
        PuppetLint::Lexer::Token.new(:LBRACE,'{',0,0),
        PuppetLint::Lexer::Token.new(:NAME,'merge',0,0),
        PuppetLint::Lexer::Token.new(:WHITESPACE,' ',0,0),
        PuppetLint::Lexer::Token.new(:FARROW,'=>',0,0),
        PuppetLint::Lexer::Token.new(:WHITESPACE,' ',0,0),
        PuppetLint::Lexer::Token.new(:NAME,merge_value,0,0),
        PuppetLint::Lexer::Token.new(:RBRACE,'}',0,0),
      ].reverse_each do |new_token|
        tokens.insert(index, new_token)
      end

      # Adds the '.include' at end
      if problem[:token].value == 'hiera_include'
        index = next_token_index_of(:RPAREN, problem[:token])
        [
          PuppetLint::Lexer::Token.new(:DOT,'.',0,0),
          PuppetLint::Lexer::Token.new(:NAME,'include',0,0),
        ].reverse_each do |new_token|
          tokens.insert(index + 1, new_token)
        end
      end
    end

    problem[:token].value = 'lookup'
  end

  # There are functions within puppet-lint that should do what this function does,
  # but I can't figure out how they work.
  def next_token_index_of(type, token)
    index_token = token
    until index_token.type == type || index_token.nil?
      index_token = index_token.next_token
    end

    return tokens.index(index_token) unless index_token.nil?
  end
end
