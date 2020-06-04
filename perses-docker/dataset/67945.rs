// build: nightly-2020-01-06
// error: internal compiler error

use std::marker::PhantomData;

use std::mem::{self, MaybeUninit};

struct Bug<S> {
    A: [(); {
        let x: S = MaybeUninit::uninit();
        let b = &*(&x as *const _ as *const S);
        0
    }],
}
