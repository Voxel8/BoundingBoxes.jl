#! /usr/bin/env julia

using BoundingBoxes
using Base.Test

# Initialize Bounding box
@boundingbox Bounds2F, "x", "y"
bb2f = Bounds2F{Float64}(1,2,3,4)

@test bb2f.x_max == 1
@test bb2f.y_max == 2
@test bb2f.x_min == 3
@test bb2f.y_min == 4

@boundingbox Bounds2I, "x", "y"
bb2i = Bounds2I{Int64}(4,3,2,1)

@test bb2i.x_max == 4
@test bb2i.y_max == 3
@test bb2i.x_min == 2
@test bb2i.y_min == 1

# test equality
bb2e = Bounds2I{Int64}(4,3,2,1)

@test bb2i == bb2e
@test bb2i != bb2f

# test empty bounds
bb2f = Bounds2I(Float64)

@test bb2f == Bounds2I{Float64}(-Inf,-Inf,Inf,Inf)
@test typeof(bb2f) == Bounds2I{Float64}

# test arg promoting
bb2a = Bounds2I(1,2,3,4.0)
@test typeof(bb2a) == Bounds2I{Float64}

bb2b = Bounds2I(1,2,3,4.0+im)
@test typeof(bb2b) == Bounds2I{Complex{Float64}}

# test bounds updating
@boundingbox Bounds3, "x", "y", "z"
bb3a = Bounds3(Float64)
@test update!(bb3a, [1,2,3]) == nothing
update!(bb3a, [4,5,6])
@test bb3a.x_max == 4
@test bb3a.y_max == 5
@test bb3a.z_max == 6
@test bb3a.x_min == 1
@test bb3a.y_min == 2
@test bb3a.z_min == 3

# test in
bb3a = Bounds3{Float64}(0.5,0.5,0.5,0.25,0.25,0.25)
bb3b = Bounds3{Float64}(1,1,1,0,0,0)
@test in(bb3a,bb3b)
@test !in(bb3b,bb3a)

