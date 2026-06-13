import FirebaseFirestore

struct UserModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let firstName: String
    let lastName: String
    let pingStatus: String?
}

