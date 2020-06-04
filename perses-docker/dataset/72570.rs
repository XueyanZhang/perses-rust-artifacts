// build: nightly-2020-05-24
// target: aarch64-unknown-linux-gnu 
// error: internal compiler error

#![feature(asm)]

pub fn foo() {
    let buf = "Hello from asm!\n";
    let ret: i32;
    unsafe {
        asm!(
            "syscall",
            in("rax") 1, // syscall number
            in("rdi") 1, // fd
            in("rsi") buf.as_ptr(),
            in("rdx") buf.len(),
            out("rcx") _, // clobbered by syscalls
            out("r11") _, // clobbered by syscalls
            lateout("rax") ret,
        );
    }
    println!("write returned: {}", ret);
}
