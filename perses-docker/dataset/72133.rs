// build: nightly-2020-05-10
// error: internal compiler error
#![feature(const_raw_ptr_deref)]

mod internal {
    static UNIT: &'static () = &();

    static OTHER_UNIT: &'static u8 = unsafe { &*(&self::UNIT as *const _ as *const u8) };
}

fn main() {}
