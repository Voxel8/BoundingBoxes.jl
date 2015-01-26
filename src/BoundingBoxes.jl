module BoundingBoxes


abstract AbstractBoundingBox{T, N}

type Bounds{T} <: AbstractBounds{T, N}
    min::T
    max::T
end

function Bounds{T}(max::T, min::T)
    n = length(max)
    m = length(min)
    @assert length(max) == length(min)
    Bounds{T, n}(max, min)
end

max(b::Bounds) = b.max
min(b::Bounds) = b.min

# TODO provide optimized Array operations



end # module
