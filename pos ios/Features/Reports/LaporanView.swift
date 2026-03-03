import SwiftUI

struct LaporanView: View {
    let store: BusinessUnit
    
    
    @State private var itemStartDate = Date()
    @State private var itemEndDate = Date()
    @State private var itemArticleGroup = ""
    @State private var isLoadingItem = false
    
    
    @State private var salesStartDate = Date()
    @State private var salesEndDate = Date()
    @State private var salesPerson = ""
    @State private var isLoadingSales = false
    
    
    @State private var summaryStartDate = Date()
    @State private var summaryEndDate = Date()
    @State private var summaryArticleGroup = ""
    @State private var isLoadingSummary = false
    
    
    @State private var dailyStartDate = Date()
    @State private var dailyEndDate = Date()
    @State private var isLoadingDaily = false
    
    
    @State private var salesmanList: [SalesPerson] = []
    
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    
                    ReportFormCard(
                        title: "Sales Report Per Item",
                        startDate: $itemStartDate,
                        endDate: $itemEndDate,
                        showArticleGroup: true,
                        articleGroup: $itemArticleGroup,
                        showSalesman: false,
                        salesman: .constant(""),
                        onDownload: {
                            downloadReportPDF(
                                endpoint: "/report/per-item",
                                start: itemStartDate,
                                end: itemEndDate,
                                articleGroup: itemArticleGroup,
                                salesman: nil,
                                loadingState: $isLoadingItem
                            )
                        },
                        isLoading: isLoadingItem
                    )
                    
                    
                    ReportFormCard(
                        title: "Sales Report Per Sales Person",
                        startDate: $salesStartDate,
                        endDate: $salesEndDate,
                        showArticleGroup: false,
                        articleGroup: .constant(""),
                        showSalesman: true,
                        salesman: $salesPerson,
                        salesmanList: salesmanList,
                        onDownload: {
                            downloadReportPDF(
                                endpoint: "/report/per-sales-person",
                                start: salesStartDate,
                                end: salesEndDate,
                                articleGroup: nil,
                                salesman: salesPerson,
                                loadingState: $isLoadingSales
                            )
                        },
                        isLoading: isLoadingSales
                    )
                    
                    
                    ReportFormCard(
                        title: "Daily Cashier Report Summary",
                        startDate: $summaryStartDate,
                        endDate: $summaryEndDate,
                        showArticleGroup: true,
                        articleGroup: $summaryArticleGroup,
                        showSalesman: false,
                        salesman: .constant(""),
                        onDownload: {
                            downloadReportPDF(
                                endpoint: "/report/daily-cashier-summary",
                                start: summaryStartDate,
                                end: summaryEndDate,
                                articleGroup: summaryArticleGroup,
                                salesman: nil,
                                loadingState: $isLoadingSummary
                            )
                        },
                        isLoading: isLoadingSummary
                    )
                    
                    
                    ReportFormCard(
                        title: "Daily Cashier Report",
                        startDate: $dailyStartDate,
                        endDate: $dailyEndDate,
                        showArticleGroup: false,
                        articleGroup: .constant(""),
                        showSalesman: false,
                        salesman: .constant(""),
                        onDownload: {
                            downloadReportPDF(
                                endpoint: "/report/daily-cashier",
                                start: dailyStartDate,
                                end: dailyEndDate,
                                articleGroup: nil,
                                salesman: nil,
                                loadingState: $isLoadingDaily
                            )
                        },
                        isLoading: isLoadingDaily
                    )
                    
                }
                .padding(20)
                .padding(.bottom, 80) 
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Laporan")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                fetchSalesmanData()
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Download Gagal"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    
    private func fetchSalesmanData() {
        let endpoint = "/pos/salesman/\(store.siteCode)"
        NetworkManager.shared.request(endpoint: endpoint, customBaseURL: AppConfig.erpURL, config: .withBuCode) { (result: Result<SalesPersonResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let data = response.outData {
                        self.salesmanList = data
                    }
                case .failure(let err):
                    print("Gagal fetch salesman: \(err.localizedDescription)")
                }
            }
        }
    }
    
    
    private func downloadReportPDF(
        endpoint: String,
        start: Date, end: Date,
        articleGroup: String?,
        salesman: String?,
        loadingState: Binding<Bool>
    ) {
        loadingState.wrappedValue = true
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let startStr = formatter.string(from: start)
        let endStr = formatter.string(from: end)
        
        var payload: [String: Any] = [
            "date_from": startStr,
            "date_to": endStr,
            "siteCode": store.siteCode,
            "type": "pdf"
        ]
        
        if let article = articleGroup, !article.isEmpty {
            payload["article_group"] = article
        }
        
        if let sales = salesman, !sales.isEmpty {
            payload["sales_person_code"] = sales
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: payload) else {
            loadingState.wrappedValue = false
            return
        }
        
        
        NetworkManager.shared.downloadPDF(
            endpoint: endpoint,
            body: httpBody,
            config: .withBuCode
        ) { result in
            DispatchQueue.main.async {
                loadingState.wrappedValue = false
                switch result {
                case .success(let fileURL):
                    presentShareSheet(for: fileURL)
                case .failure(let error):
                    print("Gagal Download: \(error.localizedDescription)")
                    self.errorMessage = "Terjadi kesalahan saat mengunduh laporan: \(error.localizedDescription)"
                    self.showError = true
                }
            }
        }
    }
    
    
    private func presentShareSheet(for url: URL) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else { return }
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = window
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
            activityVC.popoverPresentationController?.permittedArrowDirections = []
        }
        
        rootVC.present(activityVC, animated: true, completion: nil)
    }
}
