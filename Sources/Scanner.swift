class Scanner {
    let source: String
    var tokens = [Token]()
    private var start = 0
    private var current = 0
    private var line = 1

    private static let keywords: [String: TokenType] = [
        "and": .AND,
        "class": .CLASS,
        "else": .ELSE,
        "false": .FALSE,
        "for": .FOR,
        "fun": .FUN,
        "if": .IF,
        "nil": .NIL,
        "or": .OR,
        "print": .PRINT,
        "return": .RETURN,
        "super": .SUPER,
        "this": .THIS,
        "true": .TRUE,
        "var": .VAR,
        "while": .WHILE,
    ]

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
        case "!": addToken(match("=") ? .BANG_EQUAL : .BANG)
        case "=": addToken(match("=") ? .EQUAL_EQUAL : .EQUAL)
        case "<": addToken(match("=") ? .LESS_EQUAL : .LESS)
        case ">": addToken(match("=") ? .GREATER_EQUAL : .GREATER)
        case "/":
            if match("/") {
                while peek() != "\n" && !isAtEnd() {
                    _ = advance()
                }
            } else {
                addToken(.SLASH)
            }
        case " ", "\r", "\t": break
        case "\n": line += 1
        case "\"": string()
        default:
            if isDigit(c) {
                number()
            } else if isAlpha(c) {
                identifier()
            } else {
                fatalError("Unexpected character.")
            }
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

    private func match(_ expected: Character) -> Bool {
        if isAtEnd() {
            return false
        }
        if source[source.index(source.startIndex, offsetBy: current)] != expected {
            return false
        }

        current += 1
        return true
    }

    private func peek() -> Character {
        if isAtEnd() {
            return "\0"
        }
        return source[source.index(source.startIndex, offsetBy: current)]
    }

    private func string() {
        while peek() != "\"" && !isAtEnd() {
            if peek() == "\n" {
                line += 1
            }
            _ = advance()
        }

        if isAtEnd() {
            fatalError("Unterminated string.")
        }

        _ = advance()
        let value = source[
            source.index(
                source.startIndex, offsetBy: start + 1)...source.index(
                    source.startIndex, offsetBy: current - 2
                )
        ]
        addToken(.STRING, String(value))
    }

    private func number() {
        while isDigit(peek()) {
            _ = advance()
        }

        if peek() == "." && isDigit(peekNext()) {
            _ = advance()
            while isDigit(peek()) {
                _ = advance()
            }
        }

        addToken(
            .NUMBER,
            Double(
                source[
                    source.index(
                        source.startIndex, offsetBy: start)...source.index(
                            source.startIndex, offsetBy: current - 1
                        )
                ]
            )
        )
    }

    private func peekNext() -> Character {
        if current + 1 >= source.count {
            return "\0"
        }
        return source[source.index(source.startIndex, offsetBy: current + 1)]
    }

    private func isDigit(_ c: Character) -> Bool {
        return c >= "0" && c <= "9"
    }

    private func isAlpha(_ c: Character) -> Bool {
        return (c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || c == "_"
    }

    private func identifier() {
        while isAlphaNumeric(peek()) {
            _ = advance()
        }

        addToken(.IDENTIFIER)

        let text = source[
            source.index(
                source.startIndex, offsetBy: start)...source.index(
                    source.startIndex, offsetBy: current - 1
                )
        ]
        if let type = Scanner.keywords[String(text)] {
            addToken(type)
        } else {
            addToken(.IDENTIFIER)
        }
    }

    private func isAlphaNumeric(_ c: Character) -> Bool {
        return isAlpha(c) || isDigit(c)
    }
}
