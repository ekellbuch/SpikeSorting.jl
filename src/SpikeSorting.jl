module SpikeSorting

#using Winston, Gtk.ShortNames
using Interpolations, DistributedArrays

export Sorting,create_multi

include("types.jl")
include("constants.jl")
include("detect.jl")
include("align.jl")
include("feature.jl")
include("reduction.jl")
include("cluster.jl")
include("run.jl")
#include("gui.jl")           

end