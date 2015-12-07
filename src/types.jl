
export Algorithm

abstract Algorithm

abstract Detect <: Algorithm
abstract Align <:Algorithm
abstract Cluster <:Algorithm
abstract Feature <:Algorithm
abstract Reduction <:Algorithm

type Sorting{D<:Detect,C<:Cluster,A<:Align,F<:Feature,R<:Reduction}
    d::D
    c::C
    a::A
    f::F
    r::R
    id::Int64
    sigend::Array{Int64,1}
    index::Int64
    p_temp::Array{Float64,1}
    numSpikes::Int64
    features::Array{Float64,1}
    fullfeature::Array{Float64,1}
    dims::Array{Int64,1}
    thres::Float64
    neuronnum::Array{Int64,1}
    waveforms::Array{UnitRange{Int64},1}
    waveform::Array{Float64,1}
end

function Sorting(d::Detect,c::Cluster,a::Align,f::Feature,r::Reduction)

    #determine size of alignment output
    wavelength=mysize(a)

    #determine feature size
    fulllength=mysize(f,wavelength)

    if typeof(r)==ReductionNone
        reducedims=fulllength
    else
        r=typeof(r)(fulllength,r.mydims)
        reducedims=r.mydims
    end
    f=typeof(f)(wavelength,reducedims)
    c=typeof(c)(reducedims)
    Sorting(d,c,a,f,r,
            1,zeros(Int64,window+window_half),0,
            zeros(Float64,window*2),2,zeros(Float64,reducedims),zeros(Float64,fulllength),
            collect(1:reducedims),1.0,zeros(Int64,100),
            Array(UnitRange{Int64},100),zeros(Float64,wavelength))   
end

function create_multi(d::Detect,c::Cluster,a::Align,f::Feature,r::Reduction,num::Int64,par=false)
    st=Array(Sorting{typeof(d),typeof(c),typeof(a),typeof(f),typeof(r)},num)

    for i=1:num
        st[i]=Sorting(typeof(d)(),typeof(c)(),typeof(a)(),typeof(f)(),typeof(r)())
        st[i].id=i
    end

    if par==true
        st=distribute(st)
    end

    st
    
end
    