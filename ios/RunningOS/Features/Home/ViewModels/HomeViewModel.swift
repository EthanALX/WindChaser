import Foundation
import Combine

/// 首页 ViewModel
@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var uiState: HomeUiState = .loading
    @Published var selectedRoute: Route?

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let getUserStats: GetUserStatsUseCase
    private let getLatestActivity: GetLatestActivityUseCase
    private let getAllRoutes: GetAllRoutesUseCase
    private let syncData: SyncDataUseCase

    // MARK: - Init

    init(
        getUserStats: GetUserStatsUseCase,
        getLatestActivity: GetLatestActivityUseCase,
        getAllRoutes: GetAllRoutesUseCase,
        syncData: SyncDataUseCase
    ) {
        self.getUserStats = getUserStats
        self.getLatestActivity = getLatestActivity
        self.getAllRoutes = getAllRoutes
        self.syncData = syncData
    }

    convenience init() {
        self.init(
            getUserStats: DIContainer.shared.resolve(),
            getLatestActivity: DIContainer.shared.resolve(),
            getAllRoutes: DIContainer.shared.resolve(),
            syncData: DIContainer.shared.resolve()
        )
    }

    // MARK: - Public Methods

    func loadData() {
        Task {
            await loadUserStats()
            await loadRoutes()
        }
    }

    func selectRoute(_ route: Route) {
        selectedRoute = route
    }

    func refresh() {
        syncData.execute()
            .sink { completion in
                // Handle completion
            } receiveValue: { [weak self] _ in
                self?.loadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func loadUserStats() async {
        getUserStats.execute()
            .sink { completion in
                // Handle completion
            } receiveValue: { [weak self] stats in
                self?.uiState = .success(
                    stats: stats,
                    latestActivityName: "Midnight Run - Shinjuku"
                )
            }
            .store(in: &cancellables)
    }

    private func loadRoutes() async {
        getAllRoutes.execute()
            .sink { completion in
                // Handle completion
            } receiveValue: { [weak self] routes in
                if let firstRoute = routes.first {
                    self?.selectedRoute = firstRoute
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UI State

enum HomeUiState {
    case loading
    case success(stats: UserStats, latestActivityName: String)
    case error(String)
}
