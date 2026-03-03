import SwiftUI

struct SelectionModalView<Item: Identifiable>: View {
    @Binding var isPresented: Bool
    let title: String
    let items: [Item]
    let onSelect: (Item) -> Void
    let displayString: (Item) -> String
    
    var secondaryString: ((Item) -> String)? = nil
    
    @ObservedObject var theme = ThemeManager.shared
    @State private var searchQuery: String = ""
    
    var filteredItems: [Item] {
        if searchQuery.isEmpty {
            return items
        } else {
            return items.filter { displayString($0).lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Cari \(title)...", text: $searchQuery)
                        .textFieldStyle(PlainTextFieldStyle())
                    if !searchQuery.isEmpty {
                        Button(action: { searchQuery = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(16)
                
                List {
                    ForEach(filteredItems) { item in
                        Button(action: {
                            onSelect(item)
                            isPresented = false
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(displayString(item))
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    if let secondary = secondaryString?(item) {
                                        Text(secondary)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(theme.primaryColor.opacity(0.5))
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Pilih \(title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.headline)
                    }
                }
            }
        }
    }
}
