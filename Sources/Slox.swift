import ArgumentParser
import Foundation

@main
struct Slox: ParsableCommand {
    @Argument var path: String?

    mutating func run() {
        if path == nil {
            runPrompt()
        } else {
            runFile(path!)
        }
    }

    private func runFile(_ path: String) {
        do {
            let source = try String(contentsOfFile: path)
            run(source)
        } catch {
            print("Could not read file \(path)")
            return
        }
    }

    private func runPrompt() {
        while true {
            print("> ", terminator: "")
            let line = readLine()
            if line == nil {
                break
            }
            run(line!)
        }
    }

    private func run(_ source: String) {
        for token in source.split(separator: " ") {
            print(token)
        }
    }
}
