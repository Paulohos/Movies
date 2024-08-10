import AppConfiguration
import SharedModels
import XCTest

@testable import PopularMovies

final class PopularMoviesTests: XCTestCase {
    private var sut: ListOfMoviesView.ViewModel!
    private var popularMoviesService: PopularMoviesService!
    private var environmentConfigurationService: EnvironmentConfigurationService!

    override func setUp() {
        super.setUp()
        
        popularMoviesService = .init(fetchListOfPopularMovies: { _ in .init() })
        environmentConfigurationService = .mock(bannerUrl: "www.google.com")
        makeSut()
    }

    override func tearDown() {
        sut = nil
        popularMoviesService = nil
        environmentConfigurationService = nil

        super.tearDown()
    }

    private func makeSut() {
        sut = .init(popularMoviesService: popularMoviesService, environmentConfigurationService: environmentConfigurationService)
    }

    func testOnAppearErrorRequest() async {
        // Given
        popularMoviesService = .init(fetchListOfPopularMovies: { _ in throw NSError() })
        makeSut()

        // When
        await sut.onAppear()

        // Then
        XCTAssertEqual(sut.state, .error(DefaultError.defaultError))
    }

    func testOnAppearSuccessRequest() async {
        // Given
        popularMoviesService = .init(fetchListOfPopularMovies: { _ in .mockData })
        makeSut()

        // When
        await sut.onAppear()

        // Then
        XCTAssertEqual(sut.state, .showData)
        // Then
        XCTAssertEqual(sut.response.totalPages, 2)
        XCTAssertEqual(sut.response.results.count, 3)
        
        XCTAssertFalse(sut.response.results[0].adult)
        XCTAssertEqual(sut.response.results[0].backdropPath, "/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg")
        XCTAssertEqual(sut.response.results[0].originalIitle, "Deadpool & Wolverine")
        XCTAssertEqual(sut.response.results[0].voteAverage, 7.9050000000000002)
        XCTAssertEqual(sut.response.results[0].popularity, 14413.653)
        XCTAssertEqual(sut.response.results[0].posterPath, "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg")
        XCTAssertEqual(sut.response.results[0].overview, "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.")
        XCTAssertEqual(sut.response.results[0].title, "Deadpool & Wolverine")
        XCTAssertEqual(sut.response.results[0].originalLanguage, "en")
        XCTAssertEqual(sut.response.results[0].voteCount, 1499)
        XCTAssertEqual(sut.response.results[0].releaseDate, "2024-07-24")
        XCTAssertFalse(sut.response.results[0].video)
    }

    func testLoadMoreMovies() async {
        // Given
        popularMoviesService = .init(fetchListOfPopularMovies: { [weak self] page in
            // Then
            XCTAssertEqual(page, 2)
            XCTAssertEqual(self?.sut.state, .isPrefetching)

            return .loadMoreData
        })
        makeSut()
        sut.response = .mockData
        sut.loadMoreOffset = -1

        // When
        await sut.loadMoreContent(currentItem: sut.response.results[2])

        // Then
        XCTAssertEqual(sut.response.totalPages, 2)
        XCTAssertEqual(sut.response.results.count, 4)

        XCTAssertTrue(sut.response.results[3].adult)
        XCTAssertEqual(sut.response.results[3].backdropPath, "/test.jpg")
        XCTAssertEqual(sut.response.results[3].originalIitle, "Test")
        XCTAssertEqual(sut.response.results[3].voteAverage, 10)
        XCTAssertEqual(sut.response.results[3].popularity, 10)
        XCTAssertEqual(sut.response.results[3].posterPath, "/test.jpg")
        XCTAssertEqual(sut.response.results[3].overview, "The Test.")
        XCTAssertEqual(sut.response.results[3].title, "Test")
        XCTAssertEqual(sut.response.results[3].originalLanguage, "en")
        XCTAssertEqual(sut.response.results[3].voteCount, 1000)
        XCTAssertEqual(sut.response.results[3].releaseDate, "2024-08-09")
        XCTAssertTrue(sut.response.results[3].video)
    }

    func testDidTapMovie() {
        // When
        sut.didTap(.movie)

        // Then
        XCTAssertEqual(sut.route!, .detail(movie: .movie))
    }

    func testTryAgain() async {
        // Given
        popularMoviesService = .init(fetchListOfPopularMovies: { _ in .mockData })
        makeSut()

        // When
        await sut.tryAgain()

        // Then
        XCTAssertEqual(sut.state, .showData)
        // Then
        XCTAssertEqual(sut.response.totalPages, 2)
        XCTAssertEqual(sut.response.results.count, 3)

        XCTAssertFalse(sut.response.results[0].adult)
        XCTAssertEqual(sut.response.results[0].backdropPath, "/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg")
        XCTAssertEqual(sut.response.results[0].originalIitle, "Deadpool & Wolverine")
        XCTAssertEqual(sut.response.results[0].voteAverage, 7.9050000000000002)
        XCTAssertEqual(sut.response.results[0].popularity, 14413.653)
        XCTAssertEqual(sut.response.results[0].posterPath, "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg")
        XCTAssertEqual(sut.response.results[0].overview, "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.")
        XCTAssertEqual(sut.response.results[0].title, "Deadpool & Wolverine")
        XCTAssertEqual(sut.response.results[0].originalLanguage, "en")
        XCTAssertEqual(sut.response.results[0].voteCount, 1499)
        XCTAssertEqual(sut.response.results[0].releaseDate, "2024-07-24")
        XCTAssertFalse(sut.response.results[0].video)
    }

    func testBannerBaseURL() {
        // Given
        makeSut()

        // Then
        XCTAssertEqual(sut.bannerUrl, "www.google.com/w500")
    }

    func testPosterURL() async {
        // Given
        popularMoviesService = .init(fetchListOfPopularMovies: { _ in .mockData })
        makeSut()

        // When
        await sut.onAppear()
        let url = sut.posterURL(1)

        // Then
        XCTAssertEqual(url?.absoluteString, "www.google.com/w500/oGythE98MYleE6mZlGs5oBGkux1.jpg")
    }
}

private extension PopularMoviesResponse {
    static var mockData: Self {
        .init(
            results:  [
                .init(
                    id: 1111,
                    adult: false,
                    backdropPath: "/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg",
                    originalIitle: "Deadpool & Wolverine",
                    voteAverage: 7.9050000000000002,
                    popularity: 14413.653,
                    posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
                    overview: "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
                    title: "Deadpool & Wolverine",
                    originalLanguage: "en",
                    voteCount: 1499,
                    releaseDate: "2024-07-24",
                    video: false
                ),
                .init(
                    id: 2222,
                    adult: false,
                    backdropPath: "/3q01ACG0MWm0DekhvkPFCXyPZSu.jpg",
                    originalIitle: "Bad Boys: Ride or Die",
                    voteAverage: 7.6580000000000004,
                    popularity: 4076.1889999999999,
                    posterPath: "/oGythE98MYleE6mZlGs5oBGkux1.jpg",
                    overview: "After their late former Captain is framed, Lowrey and Burnett try to clear his name, only to end up on the run themselves.",
                    title: "Bad Boys: Ride or Die",
                    originalLanguage: "en",
                    voteCount: 1377,
                    releaseDate: "2024-06-05",
                    video: false
                ),
                .init(
                    id: 3333,
                    adult: false,
                    backdropPath: "/2RVcJbWFmICRDsVxRI8F5xRmRsK.jpg",
                    originalIitle: "A Quiet Place: Day One",
                    voteAverage: 6.9880000000000004,
                    popularity: 3508.0729999999999,
                    posterPath: "/yrpPYKijwdMHyTGIOd1iK1h0Xno.jpg",
                    overview: "As New York City is invaded by alien creatures who hunt by sound, a woman named Sam fights to survive with her cat.",
                    title: "A Quiet Place: Day One",
                    originalLanguage: "en",
                    voteCount: 1096,
                    releaseDate: "2024-06-26",
                    video: false
                )
            ],
            totalPages: 2
        )
    }

    static var loadMoreData: Self {
        .init(results: [
            .movie
        ], totalPages: 2)
    }
}

private extension PopularMoviesList {
    static var movie: Self {
        .init(
            id: 4444,
            adult: true,
            backdropPath: "/test.jpg",
            originalIitle: "Test",
            voteAverage: 10,
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
