class Scanner {
    let source: String
    var tokens = [Token]()
    private var start = 0
    private var current = 0
    private var line = 1

    init(source: String) {
        self.source = source
    }

    func scanTokens() -> [Token] {
        while !isAtEnd() {
            start = current
            scanToken()
        }
        tokens.append(Token(type: .EOF, lexeme: "String", literal: nil, line: line))
        return tokens
    }

    private func isAtEnd() -> Bool {
        return current >= source.count
    }

    private func scanToken() {
        let c = advance()
        switch c {
        case "(": addToken(.LEFT_PAREN)
        case ")": addToken(.RIGHT_PAREN)
        case "{": addToken(.LEFT_BRACE)
        case "}": addToken(.RIGHT_BRACE)
        case ",": addToken(.COMMA)
        case ".": addToken(.DOT)
        case "-": addToken(.MINUS)
        case "+": addToken(.PLUS)
        case ";": addToken(.SEMICOLON)
        case "*": addToken(.STAR)
        default: fatalError("unexpected character")
        }
    }

    private func advance() -> Character {
        current += 1
        return source[source.index(source.startIndex, offsetBy: current - 1)]
    }

    private func addToken(_ type: TokenType) {
        addToken(type, nil)
    }

    private func addToken(_ type: TokenType, _ literal: Any?) {
        let text = source[
            source.index(
                source.startIndex, offsetBy: start)...source.index(
                    source.startIndex, offsetBy: current - 1
                )
        ]
        tokens.append(Token(type: type, lexeme: String(text), literal: literal, line: line))
    }
}
