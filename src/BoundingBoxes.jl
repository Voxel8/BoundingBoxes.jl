module BoundingBoxes

export @boundingbox

macro boundingbox(ex)
    # construct Bounding Box type
    types = [Expr(:(::),symbol(axe*"_max"),:T) for axe in ex.args[2:end]]
    append!(types,[Expr(:(::),symbol(axe*"_min"),:T) for axe in ex.args[2:end]])
    curly = Expr(:curly, ex.args[1], Expr(:(<:), :T, :Number))
    bound = Expr(:type, true, curly, Expr(:block, types...))

    # construct equality
    eqs = [Expr(:call, :(==),
                 dots("a", "_max", axe),
                 dots("b", "_max", axe)) for axe in ex.args[2:end]]
    append!(eqs, [Expr(:call, :(==),
                 dots("a", "_min", axe),
                 dots("b", "_min", axe)) for axe in ex.args[2:end]])
    eq_return = Expr(:return, andlist(eqs))
    eq_block = Expr(:block, eq_return)
    func_args = :(==(a::$(ex.args[1]), b::$(ex.args[1])))
    equality = Expr(:function, func_args, eq_block)


    quote
        $(esc(bound)) # create bounding box type
        $(esc(equality)) # create equality method (==)
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
