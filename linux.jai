//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



ZFP_CACHE_LINE_SIZE :: 0x100;

ZFP_VERSION_MAJOR :: 1;
ZFP_VERSION_MINOR :: 0;
ZFP_VERSION_PATCH :: 1;
ZFP_VERSION_TWEAK :: 0;

ZFP_VERSION_DEVELOP :: 1;

ZFP_CODEC :: 5;

ZFP_MIN_BITS :: 1;
ZFP_MAX_BITS :: 16658;
ZFP_MAX_PREC :: 64;
ZFP_MIN_EXP :: -1074;

ZFP_HEADER_NONE :: 0x0;
ZFP_HEADER_MAGIC :: 0x1;
ZFP_HEADER_META :: 0x2;
ZFP_HEADER_MODE :: 0x4;
ZFP_HEADER_FULL :: 0x7;

ZFP_DATA_UNUSED :: 0x01;
ZFP_DATA_PADDING :: 0x02;
ZFP_DATA_META :: 0x04;
ZFP_DATA_MISC :: 0x08;
ZFP_DATA_PAYLOAD :: 0x10;
ZFP_DATA_INDEX :: 0x20;
ZFP_DATA_CACHE :: 0x40;
ZFP_DATA_HEADER :: 0x80;
ZFP_DATA_ALL :: 0xff;

ZFP_MAGIC_BITS :: 32;
ZFP_META_BITS :: 52;
ZFP_MODE_SHORT_BITS :: 12;
ZFP_MODE_LONG_BITS :: 64;
ZFP_HEADER_MAX_BITS :: 148;
ZFP_MODE_SHORT_MAX :: (1 << ZFP_MODE_SHORT_BITS) - 2;

ZFP_ROUND_FIRST :: -1;
ZFP_ROUND_NEVER :: 0;
ZFP_ROUND_LAST :: 1;

int8 :: s8;
uint8 :: u8;
int16 :: s16;
uint16 :: u16;
int32 :: s32;
uint32 :: u32;
int64 :: s64;
uint64 :: u64;

bitstream :: struct {}

/* bit offset into stream where bits are read/written */
bitstream_offset :: uint64;

/* type for counting number of bits in a stream */
bitstream_size :: bitstream_offset;

/* type for counting a small number of bits in a stream */
bitstream_count :: u64;

stream_word_bits: u64 #elsewhere libzfp; /* bit stream granularity */

/* allocate and initialize bit stream */
stream_open :: (buffer: *void, bytes: u64) -> *bitstream #foreign libzfp;

/* close and deallocate bit stream */
stream_close :: (stream: *bitstream) -> void #foreign libzfp;

/* make a copy of bit stream to shared memory buffer */
stream_clone :: (stream: *bitstream) -> *bitstream #foreign libzfp;

/* word size in bits (equal to stream_word_bits) */
stream_alignment :: () -> bitstream_count #foreign libzfp;

/* pointer to beginning of stream */
stream_data :: (stream: *bitstream) -> *void #foreign libzfp;

/* current byte size of stream (if flushed) */
stream_size :: (stream: *bitstream) -> u64 #foreign libzfp;

/* byte capacity of stream */
stream_capacity :: (stream: *bitstream) -> u64 #foreign libzfp;

/* number of words per block */
stream_stride_block :: (stream: *bitstream) -> u64 #foreign libzfp;

/* number of blocks between consecutive blocks */
stream_stride_delta :: (stream: *bitstream) -> ptrdiff_t #foreign libzfp;

/* read single bit (0 or 1) */
stream_read_bit :: (stream: *bitstream) -> u32 #foreign libzfp;

/* write single bit */
stream_write_bit :: (stream: *bitstream, bit: u32) -> u32 #foreign libzfp;

/* read 0 <= n <= 64 bits */
stream_read_bits :: (stream: *bitstream, n: bitstream_count) -> uint64 #foreign libzfp;

/* write 0 <= n <= 64 low bits of value and return remaining bits */
stream_write_bits :: (stream: *bitstream, value: uint64, n: bitstream_count) -> uint64 #foreign libzfp;

/* return bit offset to next bit to be read */
stream_rtell :: (stream: *bitstream) -> bitstream_offset #foreign libzfp;

/* return bit offset to next bit to be written */
stream_wtell :: (stream: *bitstream) -> bitstream_offset #foreign libzfp;

/* rewind stream to beginning */
stream_rewind :: (stream: *bitstream) -> void #foreign libzfp;

/* position stream for reading at given bit offset */
stream_rseek :: (stream: *bitstream, offset: bitstream_offset) -> void #foreign libzfp;

/* position stream for writing at given bit offset */
stream_wseek :: (stream: *bitstream, offset: bitstream_offset) -> void #foreign libzfp;

/* skip over the next n bits */
stream_skip :: (stream: *bitstream, n: bitstream_size) -> void #foreign libzfp;

/* append n zero-bits to stream */
stream_pad :: (stream: *bitstream, n: bitstream_size) -> void #foreign libzfp;

/* align stream on next word boundary */
stream_align :: (stream: *bitstream) -> bitstream_count #foreign libzfp;

/* flush out any remaining buffered bits */
stream_flush :: (stream: *bitstream) -> bitstream_count #foreign libzfp;

/* copy n bits from one bit stream to another */
stream_copy :: (dst: *bitstream, src: *bitstream, n: bitstream_size) -> void #foreign libzfp;

/* Boolean constants */
zfp :: enum u32 {
    _false :: 0;
    _true  :: 1;

    zfp_false :: _false;
    zfp_true  :: _true;
}

zfp_bool :: s32;

/* execution policy */
zfp_exec_policy :: enum u32 {
    serial :: 0;
    omp    :: 1;
    cuda   :: 2;

    zfp_exec_serial :: serial;
    zfp_exec_omp    :: omp;
    zfp_exec_cuda   :: cuda;
}

/* OpenMP execution parameters */
zfp_exec_params_omp :: struct {
    threads:    u32; /* number of requested threads */
    chunk_size: u32; /* number of blocks per chunk (1D only) */
}

zfp_execution :: struct {
    policy: zfp_exec_policy; /* execution policy (serial, omp, ...) */
    params: *void; /* execution parameters */
}

/* compressed stream; use accessors to get/set members */
zfp_stream :: struct {
    minbits: u32; /* minimum number of bits to store per block */
    maxbits: u32; /* maximum number of bits to store per block */
    maxprec: u32; /* maximum number of bit planes to store */
    minexp:  s32; /* minimum floating point bit plane number to store */
    stream:  *bitstream; /* compressed bit stream */
    exec:    zfp_execution; /* execution policy and parameters */
}

/* compression mode */
zfp_mode :: enum u32 {
    _null           :: 0;
    expert          :: 1;
    fixed_rate      :: 2;
    fixed_precision :: 3;
    fixed_accuracy  :: 4;
    reversible      :: 5;

    zfp_mode_null            :: _null;
    zfp_mode_expert          :: expert;
    zfp_mode_fixed_rate      :: fixed_rate;
    zfp_mode_fixed_precision :: fixed_precision;
    zfp_mode_fixed_accuracy  :: fixed_accuracy;
    zfp_mode_reversible      :: reversible;
}

/* compression mode and parameter settings */
zfp_config :: struct {
    mode: zfp_mode; /* compression mode */
    arg:  union {
        rate:      float64; /* compressed bits/value (negative for word alignment) */
        precision: u32; /* uncompressed bits/value */
        tolerance: float64; /* absolute error tolerance */
        expert:    struct {
            minbits: u32; /* min number of compressed bits/block */
            maxbits: u32; /* max number of compressed bits/block */
            maxprec: u32; /* max number of uncompressed bits/value */
            minexp:  s32; /* min floating point bit plane number to store */
        }; /* expert mode arguments */
    }; /* arguments corresponding to compression mode */
}

/* scalar type */
zfp_type :: enum u32 {
    none   :: 0;
    int32  :: 1;
    int64  :: 2;
    _float :: 3;
    double :: 4;

    zfp_type_none   :: none;
    zfp_type_int32  :: int32;
    zfp_type_int64  :: int64;
    zfp_type_float  :: _float;
    zfp_type_double :: double;
}

/* uncompressed array; use accessors to get/set members */
zfp_field :: struct {
    type: zfp_type; /* scalar type (e.g. int32, double) */
    nx:   u64; /* sizes (zero for unused dimensions) */
    ny:   u64; /* sizes (zero for unused dimensions) */
    nz:   u64; /* sizes (zero for unused dimensions) */
    nw:   u64; /* sizes (zero for unused dimensions) */
    sx:   ptrdiff_t; /* strides (zero for contiguous array a[nw][nz][ny][nx]) */
    sy:   ptrdiff_t; /* strides (zero for contiguous array a[nw][nz][ny][nx]) */
    sz:   ptrdiff_t; /* strides (zero for contiguous array a[nw][nz][ny][nx]) */
    sw:   ptrdiff_t; /* strides (zero for contiguous array a[nw][nz][ny][nx]) */
    data: *void; /* pointer to array data */
}

zfp_codec_version: u32 #elsewhere libzfp; /* codec version ZFP_CODEC */
zfp_library_version: u32 #elsewhere libzfp; /* library version ZFP_VERSION */
zfp_version_string: *u8 #elsewhere libzfp; /* verbose version string */

zfp_type_size :: (type: zfp_type) -> u64 #foreign libzfp;

zfp_stream_open :: (stream: *bitstream) -> *zfp_stream #foreign libzfp;

/* close and deallocate compressed stream (does not affect bit stream) */
zfp_stream_close :: (stream: *zfp_stream) -> void #foreign libzfp;

zfp_stream_bit_stream :: (stream: *zfp_stream) -> *bitstream #foreign libzfp;

zfp_stream_compression_mode :: (stream: *zfp_stream) -> zfp_mode #foreign libzfp;

zfp_stream_rate :: (stream: *zfp_stream, dims: u32) -> float64 #foreign libzfp;

zfp_stream_precision :: (stream: *zfp_stream) -> u32 #foreign libzfp;

zfp_stream_accuracy :: (stream: *zfp_stream) -> float64 #foreign libzfp;

zfp_stream_mode :: (stream: *zfp_stream) -> uint64 #foreign libzfp;

/* get all compression parameters (pointers may be NULL) */
zfp_stream_params :: (stream: *zfp_stream, minbits: *u32, maxbits: *u32, maxprec: *u32, minexp: *s32) -> void #foreign libzfp;

zfp_stream_compressed_size :: (stream: *zfp_stream) -> u64 #foreign libzfp;

zfp_stream_maximum_size :: (stream: *zfp_stream, field: *zfp_field) -> u64 #foreign libzfp;

/* rewind bit stream to beginning for compression or decompression */
zfp_stream_rewind :: (stream: *zfp_stream) -> void #foreign libzfp;

/* associate bit stream with compressed stream */
zfp_stream_set_bit_stream :: (stream: *zfp_stream, bs: *bitstream) -> void #foreign libzfp;

/* enable reversible (lossless) compression */
zfp_stream_set_reversible :: (stream: *zfp_stream) -> void #foreign libzfp;

zfp_stream_set_rate :: (stream: *zfp_stream, rate: float64, type: zfp_type, dims: u32, align: zfp_bool) -> float64 #foreign libzfp;

zfp_stream_set_precision :: (stream: *zfp_stream, precision: u32) -> u32 #foreign libzfp;

zfp_stream_set_accuracy :: (stream: *zfp_stream, tolerance: float64) -> float64 #foreign libzfp;

zfp_stream_set_mode :: (stream: *zfp_stream, mode: uint64) -> zfp_mode #foreign libzfp;

zfp_stream_set_params :: (stream: *zfp_stream, minbits: u32, maxbits: u32, maxprec: u32, minexp: s32) -> zfp_bool #foreign libzfp;

/* current execution policy */
zfp_stream_execution :: (stream: *zfp_stream) -> zfp_exec_policy #foreign libzfp;

zfp_stream_omp_threads :: (stream: *zfp_stream) -> u32 #foreign libzfp;

zfp_stream_omp_chunk_size :: (stream: *zfp_stream) -> u32 #foreign libzfp;

zfp_stream_set_execution :: (stream: *zfp_stream, policy: zfp_exec_policy) -> zfp_bool #foreign libzfp;

zfp_stream_set_omp_threads :: (stream: *zfp_stream, threads: u32) -> zfp_bool #foreign libzfp;

zfp_stream_set_omp_chunk_size :: (stream: *zfp_stream, chunk_size: u32) -> zfp_bool #foreign libzfp;

zfp_config_none :: () -> zfp_config #foreign libzfp;

zfp_config_rate :: (rate: float64, align: zfp_bool) -> zfp_config #foreign libzfp;

zfp_config_precision :: (precision: u32) -> zfp_config #foreign libzfp;

zfp_config_accuracy :: (tolerance: float64) -> zfp_config #foreign libzfp;

zfp_config_reversible :: () -> zfp_config #foreign libzfp;

zfp_config_expert :: (minbits: u32, maxbits: u32, maxprec: u32, minexp: s32) -> zfp_config #foreign libzfp;

zfp_field_alloc :: () -> *zfp_field #foreign libzfp;

zfp_field_1d :: (pointer: *void, type: zfp_type, nx: u64) -> *zfp_field #foreign libzfp;

zfp_field_2d :: (pointer: *void, type: zfp_type, nx: u64, ny: u64) -> *zfp_field #foreign libzfp;

zfp_field_3d :: (pointer: *void, type: zfp_type, nx: u64, ny: u64, nz: u64) -> *zfp_field #foreign libzfp;

zfp_field_4d :: (pointer: *void, type: zfp_type, nx: u64, ny: u64, nz: u64, nw: u64) -> *zfp_field #foreign libzfp;

/* deallocate field metadata */
zfp_field_free :: (field: *zfp_field) -> void #foreign libzfp;

zfp_field_pointer :: (field: *zfp_field) -> *void #foreign libzfp;

/* pointer to lowest memory address spanned by field */
zfp_field_begin :: (field: *zfp_field) -> *void #foreign libzfp;

zfp_field_type :: (field: *zfp_field) -> zfp_type #foreign libzfp;

zfp_field_precision :: (field: *zfp_field) -> u32 #foreign libzfp;

zfp_field_dimensionality :: (field: *zfp_field) -> u32 #foreign libzfp;

zfp_field_size :: (field: *zfp_field, size: *u64) -> u64 #foreign libzfp;

/* number of bytes spanned by field data including gaps (if any) */
zfp_field_size_bytes :: (field: *zfp_field) -> u64 #foreign libzfp;

zfp_field_blocks :: (field: *zfp_field) -> u64 #foreign libzfp;

zfp_field_stride :: (field: *zfp_field, stride: *ptrdiff_t) -> zfp_bool #foreign libzfp;

zfp_field_is_contiguous :: (field: *zfp_field) -> zfp_bool #foreign libzfp;

zfp_field_metadata :: (field: *zfp_field) -> uint64 #foreign libzfp;

/* set pointer to first scalar in field */
zfp_field_set_pointer :: (field: *zfp_field, pointer: *void) -> void #foreign libzfp;

zfp_field_set_type :: (field: *zfp_field, type: zfp_type) -> zfp_type #foreign libzfp;

/* set 1D field size */
zfp_field_set_size_1d :: (field: *zfp_field, nx: u64) -> void #foreign libzfp;

/* set 2D field size */
zfp_field_set_size_2d :: (field: *zfp_field, nx: u64, ny: u64) -> void #foreign libzfp;

/* set 3D field size */
zfp_field_set_size_3d :: (field: *zfp_field, nx: u64, ny: u64, nz: u64) -> void #foreign libzfp;

/* set 4D field size */
zfp_field_set_size_4d :: (field: *zfp_field, nx: u64, ny: u64, nz: u64, nw: u64) -> void #foreign libzfp;

/* set 1D field stride in number of scalars */
zfp_field_set_stride_1d :: (field: *zfp_field, sx: ptrdiff_t) -> void #foreign libzfp;

/* set 2D field strides in number of scalars */
zfp_field_set_stride_2d :: (field: *zfp_field, sx: ptrdiff_t, sy: ptrdiff_t) -> void #foreign libzfp;

/* set 3D field strides in number of scalars */
zfp_field_set_stride_3d :: (field: *zfp_field, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> void #foreign libzfp;

/* set 4D field strides in number of scalars */
zfp_field_set_stride_4d :: (field: *zfp_field, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> void #foreign libzfp;

zfp_field_set_metadata :: (field: *zfp_field, meta: uint64) -> zfp_bool #foreign libzfp;

zfp_compress :: (stream: *zfp_stream, field: *zfp_field) -> u64 #foreign libzfp;

zfp_decompress :: (stream: *zfp_stream, field: *zfp_field) -> u64 #foreign libzfp;

zfp_write_header :: (stream: *zfp_stream, field: *zfp_field, mask: u32) -> u64 #foreign libzfp;

zfp_read_header :: (stream: *zfp_stream, field: *zfp_field, mask: u32) -> u64 #foreign libzfp;

/* flush bit stream--must be called after last encode call or between seeks */
zfp_stream_flush :: (stream: *zfp_stream) -> u64 #foreign libzfp;

/* align bit stream on next word boundary (decoding analogy to flush) */
zfp_stream_align :: (stream: *zfp_stream) -> u64 #foreign libzfp;

/* encode 1D contiguous block of 4 values */
zfp_encode_block_int32_1 :: (stream: *zfp_stream, block: *int32) -> u64 #foreign libzfp;
zfp_encode_block_int64_1 :: (stream: *zfp_stream, block: *int64) -> u64 #foreign libzfp;
zfp_encode_block_float_1 :: (stream: *zfp_stream, block: *float) -> u64 #foreign libzfp;
zfp_encode_block_double_1 :: (stream: *zfp_stream, block: *float64) -> u64 #foreign libzfp;

/* encode 1D complete or partial block from strided array */
zfp_encode_block_strided_int32_1 :: (stream: *zfp_stream, p: *int32, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_int64_1 :: (stream: *zfp_stream, p: *int64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_float_1 :: (stream: *zfp_stream, p: *float, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_double_1 :: (stream: *zfp_stream, p: *float64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_int32_1 :: (stream: *zfp_stream, p: *int32, nx: u64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_int64_1 :: (stream: *zfp_stream, p: *int64, nx: u64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_float_1 :: (stream: *zfp_stream, p: *float, nx: u64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_double_1 :: (stream: *zfp_stream, p: *float64, nx: u64, sx: ptrdiff_t) -> u64 #foreign libzfp;

/* encode 2D contiguous block of 4x4 values */
zfp_encode_block_int32_2 :: (stream: *zfp_stream, block: *int32) -> u64 #foreign libzfp;
zfp_encode_block_int64_2 :: (stream: *zfp_stream, block: *int64) -> u64 #foreign libzfp;
zfp_encode_block_float_2 :: (stream: *zfp_stream, block: *float) -> u64 #foreign libzfp;
zfp_encode_block_double_2 :: (stream: *zfp_stream, block: *float64) -> u64 #foreign libzfp;

/* encode 2D complete or partial block from strided array */
zfp_encode_partial_block_strided_int32_2 :: (stream: *zfp_stream, p: *int32, nx: u64, ny: u64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_int64_2 :: (stream: *zfp_stream, p: *int64, nx: u64, ny: u64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_float_2 :: (stream: *zfp_stream, p: *float, nx: u64, ny: u64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_double_2 :: (stream: *zfp_stream, p: *float64, nx: u64, ny: u64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_int32_2 :: (stream: *zfp_stream, p: *int32, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_int64_2 :: (stream: *zfp_stream, p: *int64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_float_2 :: (stream: *zfp_stream, p: *float, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_double_2 :: (stream: *zfp_stream, p: *float64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;

/* encode 3D contiguous block of 4x4x4 values */
zfp_encode_block_int32_3 :: (stream: *zfp_stream, block: *int32) -> u64 #foreign libzfp;
zfp_encode_block_int64_3 :: (stream: *zfp_stream, block: *int64) -> u64 #foreign libzfp;
zfp_encode_block_float_3 :: (stream: *zfp_stream, block: *float) -> u64 #foreign libzfp;
zfp_encode_block_double_3 :: (stream: *zfp_stream, block: *float64) -> u64 #foreign libzfp;

/* encode 3D complete or partial block from strided array */
zfp_encode_block_strided_int32_3 :: (stream: *zfp_stream, p: *int32, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_int64_3 :: (stream: *zfp_stream, p: *int64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_float_3 :: (stream: *zfp_stream, p: *float, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_double_3 :: (stream: *zfp_stream, p: *float64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_int32_3 :: (stream: *zfp_stream, p: *int32, nx: u64, ny: u64, nz: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_int64_3 :: (stream: *zfp_stream, p: *int64, nx: u64, ny: u64, nz: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_float_3 :: (stream: *zfp_stream, p: *float, nx: u64, ny: u64, nz: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_double_3 :: (stream: *zfp_stream, p: *float64, nx: u64, ny: u64, nz: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;

/* encode 4D contiguous block of 4x4x4x4 values */
zfp_encode_block_int32_4 :: (stream: *zfp_stream, block: *int32) -> u64 #foreign libzfp;
zfp_encode_block_int64_4 :: (stream: *zfp_stream, block: *int64) -> u64 #foreign libzfp;
zfp_encode_block_float_4 :: (stream: *zfp_stream, block: *float) -> u64 #foreign libzfp;
zfp_encode_block_double_4 :: (stream: *zfp_stream, block: *float64) -> u64 #foreign libzfp;

/* encode 4D complete or partial block from strided array */
zfp_encode_block_strided_int32_4 :: (stream: *zfp_stream, p: *int32, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_int64_4 :: (stream: *zfp_stream, p: *int64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_float_4 :: (stream: *zfp_stream, p: *float, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_block_strided_double_4 :: (stream: *zfp_stream, p: *float64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_int32_4 :: (stream: *zfp_stream, p: *int32, nx: u64, ny: u64, nz: u64, nw: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_int64_4 :: (stream: *zfp_stream, p: *int64, nx: u64, ny: u64, nz: u64, nw: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_float_4 :: (stream: *zfp_stream, p: *float, nx: u64, ny: u64, nz: u64, nw: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_encode_partial_block_strided_double_4 :: (stream: *zfp_stream, p: *float64, nx: u64, ny: u64, nz: u64, nw: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;

/* decode 1D contiguous block of 4 values */
zfp_decode_block_int32_1 :: (stream: *zfp_stream, block: *int32) -> u64 #foreign libzfp;
zfp_decode_block_int64_1 :: (stream: *zfp_stream, block: *int64) -> u64 #foreign libzfp;
zfp_decode_block_float_1 :: (stream: *zfp_stream, block: *float) -> u64 #foreign libzfp;
zfp_decode_block_double_1 :: (stream: *zfp_stream, block: *float64) -> u64 #foreign libzfp;

/* decode 1D complete or partial block from strided array */
zfp_decode_block_strided_int32_1 :: (stream: *zfp_stream, p: *int32, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_int64_1 :: (stream: *zfp_stream, p: *int64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_float_1 :: (stream: *zfp_stream, p: *float, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_double_1 :: (stream: *zfp_stream, p: *float64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_int32_1 :: (stream: *zfp_stream, p: *int32, nx: u64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_int64_1 :: (stream: *zfp_stream, p: *int64, nx: u64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_float_1 :: (stream: *zfp_stream, p: *float, nx: u64, sx: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_double_1 :: (stream: *zfp_stream, p: *float64, nx: u64, sx: ptrdiff_t) -> u64 #foreign libzfp;

/* decode 2D contiguous block of 4x4 values */
zfp_decode_block_int32_2 :: (stream: *zfp_stream, block: *int32) -> u64 #foreign libzfp;
zfp_decode_block_int64_2 :: (stream: *zfp_stream, block: *int64) -> u64 #foreign libzfp;
zfp_decode_block_float_2 :: (stream: *zfp_stream, block: *float) -> u64 #foreign libzfp;
zfp_decode_block_double_2 :: (stream: *zfp_stream, block: *float64) -> u64 #foreign libzfp;

/* decode 2D complete or partial block from strided array */
zfp_decode_block_strided_int32_2 :: (stream: *zfp_stream, p: *int32, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_int64_2 :: (stream: *zfp_stream, p: *int64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_float_2 :: (stream: *zfp_stream, p: *float, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_double_2 :: (stream: *zfp_stream, p: *float64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_int32_2 :: (stream: *zfp_stream, p: *int32, nx: u64, ny: u64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_int64_2 :: (stream: *zfp_stream, p: *int64, nx: u64, ny: u64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_float_2 :: (stream: *zfp_stream, p: *float, nx: u64, ny: u64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_double_2 :: (stream: *zfp_stream, p: *float64, nx: u64, ny: u64, sx: ptrdiff_t, sy: ptrdiff_t) -> u64 #foreign libzfp;

/* decode 3D contiguous block of 4x4x4 values */
zfp_decode_block_int32_3 :: (stream: *zfp_stream, block: *int32) -> u64 #foreign libzfp;
zfp_decode_block_int64_3 :: (stream: *zfp_stream, block: *int64) -> u64 #foreign libzfp;
zfp_decode_block_float_3 :: (stream: *zfp_stream, block: *float) -> u64 #foreign libzfp;
zfp_decode_block_double_3 :: (stream: *zfp_stream, block: *float64) -> u64 #foreign libzfp;

/* decode 3D complete or partial block from strided array */
zfp_decode_block_strided_int32_3 :: (stream: *zfp_stream, p: *int32, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_int64_3 :: (stream: *zfp_stream, p: *int64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_float_3 :: (stream: *zfp_stream, p: *float, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_double_3 :: (stream: *zfp_stream, p: *float64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_int32_3 :: (stream: *zfp_stream, p: *int32, nx: u64, ny: u64, nz: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_int64_3 :: (stream: *zfp_stream, p: *int64, nx: u64, ny: u64, nz: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_float_3 :: (stream: *zfp_stream, p: *float, nx: u64, ny: u64, nz: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_double_3 :: (stream: *zfp_stream, p: *float64, nx: u64, ny: u64, nz: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t) -> u64 #foreign libzfp;

/* decode 4D contiguous block of 4x4x4x4 values */
zfp_decode_block_int32_4 :: (stream: *zfp_stream, block: *int32) -> u64 #foreign libzfp;
zfp_decode_block_int64_4 :: (stream: *zfp_stream, block: *int64) -> u64 #foreign libzfp;
zfp_decode_block_float_4 :: (stream: *zfp_stream, block: *float) -> u64 #foreign libzfp;
zfp_decode_block_double_4 :: (stream: *zfp_stream, block: *float64) -> u64 #foreign libzfp;

/* decode 4D complete or partial block from strided array */
zfp_decode_block_strided_int32_4 :: (stream: *zfp_stream, p: *int32, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_int64_4 :: (stream: *zfp_stream, p: *int64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_float_4 :: (stream: *zfp_stream, p: *float, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_block_strided_double_4 :: (stream: *zfp_stream, p: *float64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_int32_4 :: (stream: *zfp_stream, p: *int32, nx: u64, ny: u64, nz: u64, nw: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_int64_4 :: (stream: *zfp_stream, p: *int64, nx: u64, ny: u64, nz: u64, nw: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_float_4 :: (stream: *zfp_stream, p: *float, nx: u64, ny: u64, nz: u64, nw: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;
zfp_decode_partial_block_strided_double_4 :: (stream: *zfp_stream, p: *float64, nx: u64, ny: u64, nz: u64, nw: u64, sx: ptrdiff_t, sy: ptrdiff_t, sz: ptrdiff_t, sw: ptrdiff_t) -> u64 #foreign libzfp;

/* convert dims-dimensional contiguous block to 32-bit integer type */
zfp_promote_int8_to_int32 :: (oblock: *int32, iblock: *int8, dims: u32) -> void #foreign libzfp;
zfp_promote_uint8_to_int32 :: (oblock: *int32, iblock: *uint8, dims: u32) -> void #foreign libzfp;
zfp_promote_int16_to_int32 :: (oblock: *int32, iblock: *int16, dims: u32) -> void #foreign libzfp;
zfp_promote_uint16_to_int32 :: (oblock: *int32, iblock: *uint16, dims: u32) -> void #foreign libzfp;

/* convert dims-dimensional contiguous block from 32-bit integer type */
zfp_demote_int32_to_int8 :: (oblock: *int8, iblock: *int32, dims: u32) -> void #foreign libzfp;
zfp_demote_int32_to_uint8 :: (oblock: *uint8, iblock: *int32, dims: u32) -> void #foreign libzfp;
zfp_demote_int32_to_int16 :: (oblock: *int16, iblock: *int32, dims: u32) -> void #foreign libzfp;
zfp_demote_int32_to_uint16 :: (oblock: *uint16, iblock: *int32, dims: u32) -> void #foreign libzfp;

#scope_file

libzfp :: #library "zfp/build/lib//libzfp";
