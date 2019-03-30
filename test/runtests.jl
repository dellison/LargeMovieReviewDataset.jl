using LargeMovieReviewDataset, Test


@testset "LargeMovieReviewDataset.jl" begin
    all_reviews = allfiles()
    @test length(all_reviews) == 100_000

    unlabelled_reviews = review_files(labels=["unsup"])
    @test length(unlabelled_reviews) == 50_000
    @test all([ismissing(review_rating(review)) for review in unlabelled_reviews])

    labeled_reviews = review_files(labels=["pos","neg"])
    @test length(labeled_reviews) == 50_000
    @test all([1 <= review_rating(review) <= 10 for review in labeled_reviews])

    @test length(trainfiles()) == length(testfiles()) == 25_000
end
