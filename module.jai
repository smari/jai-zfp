#if OS == .LINUX {
    #load "linux.jai";
}

ptrdiff_t :: int;
zfp_type_none   :: 0;
zfp_type_int32  :: 1;
zfp_type_int64  :: 2;
zfp_type_float  :: 3;
zfp_type_double :: 4;
