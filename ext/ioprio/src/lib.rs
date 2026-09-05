use magnus::{function, prelude::*, Error, Ruby};

const IOPRIO_CLASS_NONE: i32 = 0;
const IOPRIO_CLASS_RT: i32 = 1;
const IOPRIO_CLASS_BE: i32 = 2;
const IOPRIO_CLASS_IDLE: i32 = 3;

const IOPRIO_WHO_PROCESS: i32 = 1;
const IOPRIO_WHO_PGRP: i32 = 2;
const IOPRIO_WHO_USER: i32 = 3;

fn prio_class(priority: i32) -> i32 {
    priority >> 13
}

fn prio_data(priority: i32) -> i32 {
    priority & ((1_i32 << 13) - 1)
}

fn prio_value(klass: i32, data: i32) -> i32 {
    (klass << 13) | data
}

#[cfg(target_os = "linux")]
fn get(ruby: &Ruby, which: i32, who: i32) -> Result<i32, Error> {
    let ret = unsafe { libc::syscall(libc::SYS_ioprio_get, which, who) };
    if ret < 0 {
        Err(Error::new(
            ruby.exception_system_call_error(),
            std::io::Error::last_os_error().to_string(),
        ))
    } else {
        Ok(ret as i32)
    }
}

#[cfg(not(target_os = "linux"))]
fn get(ruby: &Ruby, _which: i32, _who: i32) -> Result<i32, Error> {
    Err(Error::new(
        ruby.exception_not_imp_error(),
        "ioprio_get() function is unimplemented on this machine",
    ))
}

#[cfg(target_os = "linux")]
fn set(ruby: &Ruby, which: i32, who: i32, priority: i32) -> Result<i32, Error> {
    let ret = unsafe { libc::syscall(libc::SYS_ioprio_set, which, who, priority) };
    if ret < 0 {
        Err(Error::new(
            ruby.exception_system_call_error(),
            std::io::Error::last_os_error().to_string(),
        ))
    } else {
        Ok(0)
    }
}

#[cfg(not(target_os = "linux"))]
fn set(ruby: &Ruby, _which: i32, _who: i32, _priority: i32) -> Result<i32, Error> {
    Err(Error::new(
        ruby.exception_not_imp_error(),
        "ioprio_set() function is unimplemented on this machine",
    ))
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let ioprio = ruby.define_module("Ioprio")?;
    let core_ext = ioprio.define_module("CoreExt")?;
    let process = core_ext.define_module("Process")?;
    let class_methods = process.define_module("ClassMethods")?;

    process.const_set("IOPRIO_CLASS_NONE", IOPRIO_CLASS_NONE)?;
    process.const_set("IOPRIO_CLASS_RT", IOPRIO_CLASS_RT)?;
    process.const_set("IOPRIO_CLASS_BE", IOPRIO_CLASS_BE)?;
    process.const_set("IOPRIO_CLASS_IDLE", IOPRIO_CLASS_IDLE)?;

    process.const_set("IOPRIO_WHO_PROCESS", IOPRIO_WHO_PROCESS)?;
    process.const_set("IOPRIO_WHO_PGRP", IOPRIO_WHO_PGRP)?;
    process.const_set("IOPRIO_WHO_USER", IOPRIO_WHO_USER)?;

    class_methods.define_method("ioprio_prio_class", function!(prio_class, 1))?;
    class_methods.define_method("ioprio_prio_data", function!(prio_data, 1))?;
    class_methods.define_method("ioprio_prio_value", function!(prio_value, 2))?;
    class_methods.define_method("ioprio_get", function!(get, 2))?;
    class_methods.define_method("ioprio_set", function!(set, 3))?;

    Ok(())
}
