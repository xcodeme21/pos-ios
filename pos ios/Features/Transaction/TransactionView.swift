import SwiftUI

struct TransactionView: View {
    let store: BusinessUnit
    @StateObject private var viewModel = TransactionViewModel()
    @ObservedObject var theme = ThemeManager.shared
    
    @State private var showingSalesmanModal = false
    @State private var showingCustomerModal = false
    @State private var showingCheckoutModal = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    OrderHeaderView(
                        selectedSalesman: $viewModel.selectedSalesman,
                        selectedCustomer: $viewModel.selectedCustomer,
                        onSelectSalesman: { showingSalesmanModal = true },
                        onSelectCustomer: { showingCustomerModal = true }
                    )
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    
                    ProductListView(viewModel: viewModel)
                }
                
                if !viewModel.cartItems.isEmpty {
                    CartSummaryView(
                        totalItems: viewModel.totalCartItems,
                        totalAmount: viewModel.totalAmount,
                        theme: theme,
                        action: { showingCheckoutModal = true }
                    )
                }
            }
            .navigationTitle("Transaksi")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel.salesmanList.isEmpty {
                    viewModel.fetchSalesData(siteCode: store.siteCode)
                }
            }
            
            .sheet(isPresented: $showingSalesmanModal) {
                SelectionModalView(
                    isPresented: $showingSalesmanModal,
                    title: "Sales",
                    items: viewModel.salesmanList,
                    onSelect: { salesman in
                        viewModel.selectedSalesman = salesman
                    },
                    displayString: { $0.fullName },
                    secondaryString: { $0.salesPersonId }
                )
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showingCustomerModal) {
                SelectionModalView(
                    isPresented: $showingCustomerModal,
                    title: "Customer",
                    items: viewModel.customerList,
                    onSelect: { customer in
                        viewModel.selectedCustomer = customer
                    },
                    displayString: { $0.name },
                    secondaryString: { $0.phone }
                )
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showingCheckoutModal) {
                CheckoutModalSheet(
                    isPresented: $showingCheckoutModal,
                    viewModel: viewModel
                )
                .presentationDetents([.large])
            }
        }
    }
}
