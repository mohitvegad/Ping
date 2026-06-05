import FirebaseFirestore

struct UserModel: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    let firstName: String
    let lastName: String
    let pingStatus: String?
}

extension UserModel {

    func toPingCellModel() -> PingCellModel {
        PingCellModel(
            id: id ?? "",
            title: "\(firstName) \(lastName)",
            subtitle: pingStatus ?? "",
            imageName: "person.fill",
            date: Date()
        )
    }
}
