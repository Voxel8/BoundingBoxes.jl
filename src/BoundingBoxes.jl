module BoundingBoxes

export @boundingbox

macro boundingbox(ex)
    bound_name = ex.args[1]
    axes = ex.args[2:end]
    # construct Bounding Box type
    types = [Expr(:(::),symbol(axe*"_max"),:T) for axe in axes]
    append!(types,[Expr(:(::),symbol(axe*"_min"),:T) for axe in axes])
    curly = Expr(:curly, bound_name, Expr(:(<:), :T, :Number))
    bound = Expr(:type, true, curly, Expr(:block, types...))

    # construct equality
    eqs = [Expr(:call, :(==),
                 dots("a", "_max", axe),
                 dots("b", "_max", axe)) for axe in axes]
    append!(eqs, [Expr(:call, :(==),
                 dots("a", "_min", axe),
                 dots("b", "_min", axe)) for axe in axes])
    eq_return = Expr(:return, andlist(eqs))
    eq_block = Expr(:block, eq_return)
    eq_args = :(==(a::$(bound_name), b::$(bound_name)))
    equality = Expr(:function, eq_args, eq_block)

    # construct empty bounds
    empty_max = [Expr(:call, :typemin, :T) for i = 1:length(axes)]
    empty_min = [Expr(:call, :typemax, :T) for i = 1:length(axes)]
    empty_bounds = :($(bound_name)(T) = $(bound_name){T}($(empty_max...), $(empty_min...)))

    # promotion handling function
    promote_bounds = :($(bound_name)(x...) = $(bound_name)(promote(x...)...))

    # construct bounds updating
    update_args = :(update!(a::$(bound_name), b::AbstractArray))
    update_body = [Expr(:(=), dots("a", "_max", axes[i]),
                        Expr(:call,
                            :(max), dots("a", "_max", axes[i]),
                            Expr(:ref, :b, i))
                        ) for i = 1:length(axes)]
    append!(update_body, [Expr(:(=), dots("a", "_min", axes[i]),
                            Expr(:call,
                                    :(min), dots("a", "_min", axes[i]),
                                    Expr(:ref, :b, i))
                            ) for i = 1:length(axes)])
    update_block = Expr(:block, update_body...)
    update_bounds = Expr(:function, update_args, update_block)

    quote
        $(esc(bound)) # create bounding box type
        $(esc(equality)) # create equality method (==)
        $(esc(empty_bounds)) # create empty bounds (Bounds(T))
        $(esc(promote_bounds)) # create arg promoting method
        $(esc(update_bounds)) # create method for updating against AbstractArray
    end
end

# member access
function dots(parent, elt, axe)
    return Expr(:(.), symbol(parent), QuoteNode(symbol(axe*elt)))
end

# create a list of chained "&&" Exprs
function andlist(exprs)
    last_expr = exprs[1]
    expr = Expr(:block)
    for i = 2:length(exprs)
        expr = Expr(:(&&), exprs[i], last_expr)
        last_expr = expr
    end
    return expr
end

end # module
