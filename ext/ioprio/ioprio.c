#include "ioprio.h"
#include <errno.h>
#include <ruby.h>
#include <sys/syscall.h>
#include <unistd.h>

enum
{
  IOPRIO_CLASS_NONE,
  IOPRIO_CLASS_RT,
  IOPRIO_CLASS_BE,
  IOPRIO_CLASS_IDLE,
};

enum
{
  IOPRIO_WHO_PROCESS = 1,
  IOPRIO_WHO_PGRP,
  IOPRIO_WHO_USER,
};

static VALUE
ioprio_prio_class (VALUE obj, VALUE priority)
{
  return INT2NUM (NUM2INT (priority) >> 13);
}

static VALUE
ioprio_prio_data (VALUE obj, VALUE priority)
{
  return INT2NUM (NUM2INT (priority) & ((1UL << 13) - 1));
}

static VALUE
ioprio_prio_value (VALUE obj, VALUE class, VALUE data)
{
  return INT2NUM ((NUM2INT (class) << 13) | NUM2INT (data));
}

#ifdef SYS_ioprio_get
static VALUE
ioprio_get (VALUE obj, VALUE which, VALUE who)
{
  errno = 0;
  int prio = syscall (SYS_ioprio_get, NUM2INT (which), NUM2INT (who));
  if (errno)
    rb_sys_fail (0);
  return INT2NUM (prio);
}
#else
#define ioprio_get rb_f_notimplement
#endif

#ifdef SYS_ioprio_set
static VALUE
ioprio_set (VALUE obj, VALUE which, VALUE who, VALUE priority)
{
  if (syscall (SYS_ioprio_set, NUM2INT (which), NUM2INT (who),
               NUM2INT (priority))
      < 0)
    rb_sys_fail (0);
  return INT2NUM (0);
}
#else
#define ioprio_set rb_f_notimplement
#endif

RUBY_FUNC_EXPORTED void
Init_ioprio (void)
{
  VALUE rb_mod_ioprio = rb_define_module ("Ioprio");
  VALUE rb_mod_ioprio_core_ext
      = rb_define_module_under (rb_mod_ioprio, "CoreExt");
  VALUE rb_mod_ioprio_core_ext_process
      = rb_define_module_under (rb_mod_ioprio_core_ext, "Process");
  VALUE rb_mod_ioprio_core_ext_process_class_methods = rb_define_module_under (
      rb_mod_ioprio_core_ext_process, "ClassMethods");

  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_CLASS_NONE",
                   INT2NUM (IOPRIO_CLASS_NONE));
  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_CLASS_RT",
                   INT2NUM (IOPRIO_CLASS_RT));
  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_CLASS_BE",
                   INT2NUM (IOPRIO_CLASS_BE));
  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_CLASS_IDLE",
                   INT2NUM (IOPRIO_CLASS_IDLE));

  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_WHO_PROCESS",
                   INT2NUM (IOPRIO_WHO_PROCESS));
  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_WHO_PGRP",
                   INT2NUM (IOPRIO_WHO_PGRP));
  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_WHO_USER",
                   INT2NUM (IOPRIO_WHO_USER));

  rb_define_method (rb_mod_ioprio_core_ext_process_class_methods, "ioprio_prio_class",
                    ioprio_prio_class, 1);
  rb_define_method (rb_mod_ioprio_core_ext_process_class_methods, "ioprio_prio_data",
                    ioprio_prio_data, 1);
  rb_define_method (rb_mod_ioprio_core_ext_process_class_methods, "ioprio_prio_value",
                    ioprio_prio_value, 2);
  rb_define_method (rb_mod_ioprio_core_ext_process_class_methods, "ioprio_get",
                    ioprio_get, 2);
  rb_define_method (rb_mod_ioprio_core_ext_process_class_methods, "ioprio_set",
                    ioprio_set, 3);
}
