import FirebaseFirestore

struct UserModel: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    let firstName: String
    let lastName: String
}

extension UserModel {

    func toPingCellModel() -> PingCellModel {
        PingCellModel(
            id: id ?? "",
            title: "\(firstName) \(lastName)",
            subtitle: "Tap to start chat",
            imageName: "person.fill"
        )
    }
}
