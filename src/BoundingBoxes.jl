module BoundingBoxes

export @boundingbox

macro boundingbox(ex)
    # construct Bounding Box type
    types = [Expr(:(::),symbol(axe*"_max"),:T) for axe in ex.args[2:end]]
    append!(types,[Expr(:(::),symbol(axe*"_min"),:T) for axe in ex.args[2:end]])
    curly = Expr(:curly, ex.args[1], Expr(:(<:), :T, :Number))
    bound = Expr(:type, true, curly, Expr(:block, types...))
    quote
        $(esc(bound)) # create bounding box type
    end
end

end # module
