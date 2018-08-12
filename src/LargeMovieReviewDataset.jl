module LargeMovieReviewDataset

export review_files, trainfiles, testfiles, allfiles
export review_id, review_rating

using DataDeps

const LABELS   = ["neg", "pos", "unsup"]
const DATASETS = ["train", "test"]
const RX = r"([0-9]+?)_([0-9]+?)\.txt$"

rootdir() = datadep"LargeMovieReviewDataset"

basedir() = joinpath(rootdir(), "aclImdb")

readme() = joinpath(basedir(), "README")

review_id(review) = Meta.parse(match(RX, review).captures[1])

function review_rating(review)
    rating = Meta.parse(match(RX, review).captures[2])
    if rating == 0
        return missing
    else
        return rating
    end
end

function review_files(;datasets=["train","test"], labels=["neg","pos"])
    @assert all(set in DATASETS for set in datasets)
    @assert all(label in LABELS for label in labels)
    base, files =  basedir(), []
    for dataset in datasets, label in labels
        (dataset, label) == ("test", "unsup") && continue
        for filename in readdir(joinpath(base, dataset, label))
            if occursin(r"([0-9]+)_([0-9]+)\.txt$", filename)
                push!(files, joinpath(base, dataset, label, filename))
            end
        end
    end
    return files
end

allfiles() = review_files(labels=LABELS, datasets=DATASETS)
trainfiles(;labels=["neg","pos"]) = review_files(datasets=["train"], labels=labels)
testfiles(;labels=["neg","pos"])  = review_files(datasets=["test"], labels=labels)

function __init__()
    register(DataDep("LargeMovieReviewDataset",
                     """
                     Dataset: Large Movie Review Dataset for binary sentiment classification.
                     Author: Andrew Maas
                     Website: https://ai.stanford.edu/~amaas/data/sentiment/
                     """,
                     "https://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz",
                     "c40f74a18d3b61f90feba1e17730e0d38e8b97c05fde7008942e91923d1658fe",
                     post_fetch_method = unpack))
end


end # module
