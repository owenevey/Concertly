import Foundation

extension String {
    func capitalizedFirst() -> String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
    
    func capitalizedWords() -> String {
            self.lowercased()
                .split(separator: " ")
                .map { $0.prefix(1).uppercased() + $0.dropFirst() }
                .joined(separator: " ")
        }
}
