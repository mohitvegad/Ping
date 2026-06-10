@testable import Ping

final class MockKeychain: KeychainServiceProtocol {

    var storage: [String: String] = [:]

    // MARK: - get userId
    func get(_ key: String) -> String? {
        storage[key]
    }

    // MARK: - save userId
    func save(_ value: String, key: String) {
        storage[key] = value
    }

    // MARK: - delete userId
    func delete(_ key: String) {
        storage.removeValue(forKey: key)
    }
}
