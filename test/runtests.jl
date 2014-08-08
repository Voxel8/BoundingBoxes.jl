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
