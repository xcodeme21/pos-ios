import SwiftUI

struct StoreSelectionView: View {
    @StateObject private var viewModel = StoreSelectionViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedStore: BusinessUnit?
    @State private var isShowingDashboard = false
    @State private var isLoadingDetails = false
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {

                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Cari nama atau kode toko...", text: $viewModel.searchQuery)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(12)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                

                if viewModel.businessUnits.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Memuat data...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else if viewModel.filteredStores.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(Color(.systemGray3))
                        Text("Toko tidak ditemukan")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.filteredStores) { store in
                                StoreCard(store: store) {
                                    handleStoreSelection(store)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    }
                }
                

                paginationView
            }
            .fullScreenCover(isPresented: $isShowingDashboard) {
                if let selectedStore = selectedStore {
                    DashboardView(store: selectedStore)
                }
            }
            

            if isLoadingDetails {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.3)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    Text("Menyiapkan Toko...")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(28)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            }
        }
        .navigationTitle("Pilih Toko")
        .navigationBarTitleDisplayMode(.large)

        .onAppear {
            if viewModel.businessUnits.isEmpty {
                viewModel.fetchStores()
            }
        }
    }
    
    private func handleStoreSelection(_ store: BusinessUnit) {
        isLoadingDetails = true
        selectedStore = store
        
        if let encodedData = try? JSONEncoder().encode(store) {
            UserDefaults.standard.set(encodedData, forKey: "savedStore")
        }
        UserDefaults.standard.set(store.siteCode, forKey: "buCode")
        
        viewModel.fetchStoreDetails(siteCode: store.companyCode) {
            isLoadingDetails = false
            isShowingDashboard = true
        }
    }
    
    private var paginationView: some View {
        HStack {
            Button {
                viewModel.previousPage()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Sebelumnya")
                }
                .font(.subheadline.weight(.medium))
                .foregroundColor(viewModel.hasPreviousPage ? Color(.label) : Color(.systemGray3))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(viewModel.hasPreviousPage ? Color(.systemBackground) : Color.clear)
                        .overlay(
                            Capsule().stroke(
                                viewModel.hasPreviousPage ? Color(.systemGray4) : Color.clear,
                                lineWidth: 1
                            )
                        )
                )
            }
            .disabled(!viewModel.hasPreviousPage)
            
            Spacer()
            
            Text("Halaman \(viewModel.currentPage) / \(max(1, viewModel.totalPages))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button {
                viewModel.nextPage()
            } label: {
                HStack(spacing: 4) {
                    Text("Berikutnya")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline.weight(.medium))
                .foregroundColor(viewModel.hasNextPage ? Color(.label) : Color(.systemGray3))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(viewModel.hasNextPage ? Color(.systemBackground) : Color.clear)
                        .overlay(
                            Capsule().stroke(
                                viewModel.hasNextPage ? Color(.systemGray4) : Color.clear,
                                lineWidth: 1
                            )
                        )
                )
            }
            .disabled(!viewModel.hasNextPage)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(.systemBackground).shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -4))
    }
}
