import AppConfiguration
import XCTest

@testable import PopularMovies

final class MovieDetailsViewModelTests: XCTestCase {
    private var sut: MovieDetailsView.ViewModel!
    private var environmentConfigurationService: EnvironmentConfigurationService!

    override func setUp() {
        super.setUp()

        environmentConfigurationService = .mock(bannerUrl: "www.google.com")
        makeSut()
    }

    override func tearDown() {
        sut = nil
        environmentConfigurationService = nil

        super.tearDown()
    }

    private func makeSut() {
        sut = .init(movie: .movie, environmentConfigurationService: environmentConfigurationService)
    }

    func testBannerURL() {
        makeSut()

        XCTAssertEqual(sut.bannerUrl, "www.google.com/original")
    }

    func testBackdropURL() {
        makeSut()

        XCTAssertEqual(sut.backdropURL()?.absoluteString, "www.google.com/original/test.jpg")
    }

    func testFooterText() {
        makeSut()

        XCTAssertEqual(sut.footer, "EN • 2024 • 🍅 10,89")
    }
}

private extension PopularMoviesList {
    static var movie: Self {
        .init(
            id: 4444,
            adult: true,
            backdropPath: "/test.jpg",
            originalIitle: "Test",
            voteAverage: 10.8888,
            popularity: 10,
            posterPath: "/test.jpg",
            overview: "The Test.",
            title: "Test",
            originalLanguage: "en",
            voteCount: 1000,
            releaseDate: "2024-08-09",
            video: true
        )
    }
}
