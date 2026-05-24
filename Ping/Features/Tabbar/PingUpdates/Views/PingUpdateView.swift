import SwiftUI

struct PingUpdateView: View {
    
    var body: some View {
        
            ScrollView(.vertical) {
                
                VStack(spacing: 24) {
                    
                    myStatusSection
                    
                    recentUpdatesSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .background(Color.black)
            .navigationTitle("Updates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar)
    }
}

// MARK: - Sections

private extension PingUpdateView {
    
    var myStatusSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Status")
                .font(.headline)
                .foregroundStyle(.gray)
            
            HStack(spacing: 12) {
                
                ZStack(alignment: .bottomTrailing) {
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.green)
                        .background(.black)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("My Status")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text("Tap to add status update")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
        }
    }
    
    var recentUpdatesSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Recent Updates")
                .font(.headline)
                .foregroundStyle(.gray)
            
            VStack(spacing: 18) {
                
                ForEach(0..<8, id: \.self) { _ in
                    
                    statusCell
                }
            }
        }
    }
    
    var statusCell: some View {
        
        HStack(spacing: 12) {
            
            Circle()
                .stroke(.green, lineWidth: 2)
                .frame(width: 64, height: 64)
                .overlay {
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("John Doe")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text("35 minutes ago")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    PingUpdateView()
}

