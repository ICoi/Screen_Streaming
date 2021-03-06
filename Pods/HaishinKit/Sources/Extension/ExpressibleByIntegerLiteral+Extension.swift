import Foundation

extension ExpressibleByIntegerLiteral {
    var data: Data {
        var value: Self = self
        return Data(bytes: &value, count: MemoryLayout<Self>.size)
    }

    init(data: Data) {
        let diff: Int = MemoryLayout<Self>.size - data.count
        if 0 < diff {
            var buffer = Data(repeating: 0, count: diff)
            buffer.append(data)
            self = buffer.withUnsafeBytes { $0.pointee }
            return
        }
        self = data.withUnsafeBytes { $0.pointee }
    }

    init(data: MutableRangeReplaceableRandomAccessSlice<Data>) {
        self.init(data: Data(data))
    }
}
