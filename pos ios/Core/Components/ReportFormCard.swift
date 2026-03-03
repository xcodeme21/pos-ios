import SwiftUI

struct ReportFormCard: View {
    @ObservedObject var theme = ThemeManager.shared
    
    let title: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    
    var showArticleGroup: Bool = false
    @Binding var articleGroup: String
    
    var showSalesman: Bool = false
    @Binding var salesman: String
    var salesmanList: [SalesPerson] = [] 
    
    
    let onDownload: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color(.label))
            
            VStack(spacing: 12) {
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Start Date")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ZStack {
                            Text(formatDate(startDate))
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                                .allowsHitTesting(false) 
                            
                            DatePicker("", selection: $startDate, displayedComponents: .date)
                                .labelsHidden()
                                .environment(\.locale, Locale(identifier: "id_ID"))
                                
                                .colorMultiply(.clear)
                                .onChange(of: startDate) {
                                    
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("End Date")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ZStack {
                            Text(formatDate(endDate))
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                                .allowsHitTesting(false)
                            
                            DatePicker("", selection: $endDate, displayedComponents: .date)
                                .labelsHidden()
                                .environment(\.locale, Locale(identifier: "id_ID"))
                                .colorMultiply(.clear)
                                .onChange(of: endDate) {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                
                if showArticleGroup {
                    CustomTextField(
                        placeholder: "Masukkan Article Group",
                        text: $articleGroup,
                        label: "Article Group",
                        style: .plain
                    )
                }
                
                if showSalesman {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Salesman")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Menu {
                            Button("Semua Salesman") {
                                salesman = ""
                            }
                            
                            ForEach(salesmanList) { person in
                                Button(person.fullName) {
                                    salesman = person.salesPersonId
                                }
                            }
                        } label: {
                            HStack {
                                Text(salesman.isEmpty ? "Pilih Salesman" : (salesmanList.first(where: { $0.id == salesman })?.fullName ?? salesman))
                                    .foregroundColor(salesman.isEmpty ? Color(.placeholderText) : Color(.label))
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }
                    }
                }
            }
            
            CustomButton(
                title: "Download PDF",
                action: onDownload,
                style: .primary,
                isLoading: isLoading,
                customBackground: theme.primaryColor
            )
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
