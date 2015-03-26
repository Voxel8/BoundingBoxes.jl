# BoundingBoxes

[![Build Status](https://travis-ci.org/Voxel8/BoundingBoxes.jl.svg?branch=master)](https://travis-ci.org/Voxel8/BoundingBoxes.jl)
[![Coverage Status](https://img.shields.io/coveralls/Voxel8/BoundingBoxes.jl.svg)](https://coveralls.io/r/Voxel8/BoundingBoxes.jl)

BoundingBoxes.jl is a Julia package for quickly defining bounding box types and methods.

## Install
From the Julia REPL:

**julia>** `Pkg.add("BoundingBoxes")`

## Usage
```
julia> using BoundingBoxes

julia> @boundingbox Bounds2, "x", "y"
Bounds2{T<:Number} (constructor with 3 methods)
```
Above demonstrates how to create a bounding box with the type name `Bounds2` and axe labels `"x"` and `"y"`.

Let's see what is inside...
```
julia> names(Bounds2)
4-element Array{Symbol,1}:
 :x_max
 :y_max
 :x_min
 :y_min

```
The macro create the composite type with a maximum and minimum member, which is just the axis name with a `"_max"` and `"_min"` suffix.

Let's see how we can use the `Bounds2` type we just created.
```
julia> methods(Bounds2)
# 3 methods for generic function "Bounds2":
Bounds2{T<:Number}(x_max::T<:Number,y_max::T<:Number,x_min::T<:Number,y_min::T<:Number)
Bounds2(T)
Bounds2(x...)

julia> Bounds2(Float64)
Bounds2{Float64}(-Inf,-Inf,Inf,Inf)

julia> Bounds2(Int64)
Bounds2{Int64}(-9223372036854775808,-9223372036854775808,9223372036854775807,9223372036854775807)

julia> Bounds2(1,2,3,4)
Bounds2{Int64}(1,2,3,4)

julia> Bounds2(int8(1),2,float32(3),float64(4.1))
Bounds2{Float64}(1.0,2.0,3.0,4.1)
```
There are two main ways. The first is an empty construction, which is just defined by a type. It creates the bounds with the maximums set to the `typemin` and the maximums set to the `typemax`. This ensures that when we update the bounds everything is either greater than, or less than, the element. The second way of creating a bounds is to instantiate the type directly. Type promotion is handled so the bounds all have uniform types.

We can also update the bounds:
```
julia> a = Bounds2(1,1,0,0)
Bounds2{Int64}(1,1,0,0)

julia> update!(a, [2,2])

julia> a
Bounds2{Int64}(2,2,0,0)
```

Likewise we can test equality:
```
julia> Bounds2(2,2,0,0) == Bounds2(2.0,2.0,0.0,0.0)
true
```

Finally, we can see if a bounds is inside another one:
```
julia> in(Bounds2(2,2,1,1), Bounds2(3,3,0,0))
true

julia> in(Bounds2(2,2,-1,-1), Bounds2(3,3,0,0))
false
```

## License
This package is available under the MIT "Expat" License. See [LICENSE.md](./LICENSE.md).

