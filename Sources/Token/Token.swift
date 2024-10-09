struct Token: CustomStringConvertible {
    let type: TokenType
    let lexeme: String
    let literal: Any?
    let line: Int

    var description: String {
        return "\(type) \(lexeme) \(literal ?? "")"
    }
}
