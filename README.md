# jai-zfp

These are basic bindings for [ZFP](https://github.com/LLNL/zfp) for use in Jai. See the project
page at [Lawrence Livermore National Laboratory](https://computing.llnl.gov/projects/zfp) for more 
info.

Currently only supports Linux.

To use: 

 1. Checkout module to your modules dir as "ZFP". 
 2. Initialize submodule `zfp` and build it (see README there).
 3. Import "ZFP" into your project and enjoy.

Example compression function (super naive, take as inspiration only):

```
#import "ZFP";

...
function my_compress :: (data: *float64, sizex: int, sizey: int, sizez: int) -> string {
    output : string;

    type: zfp_type = zfp_type_double;
    field := zfp_field_3d(data, type, sizex, sizey, sizez);
    zfp := zfp_stream_open(null);
    zfp_stream_set_accuracy(zfp, 0.0001);

    output.count = xx zfp_stream_maximum_size(zfp, field);
    output.data = alloc(output.count);

    stream := stream_open(destination.data, destination.count);
    zfp_stream_set_bit_stream(zfp, stream);
    zfp_stream_rewind(zfp);

    zfpsize := zfp_compress(zfp, field);

    zfp_field_free(field);
    zfp_stream_close(zfp);
    stream_close(stream);

    return output;
}
```

# Authors

 * Smári McCarthy

# License

BSD 3-Clause License

Copyright (c) 2024, Ecosophy ehf.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
