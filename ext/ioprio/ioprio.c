#include "ioprio.h"
#include <errno.h>
#include <ruby.h>
#include <sys/syscall.h>
#include <unistd.h>

enum
{
  IOPRIO_WHO_PROCESS = 1,
  IOPRIO_WHO_PGRP,
  IOPRIO_WHO_USER,
};

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

  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_WHO_PROCESS",
                   INT2NUM (IOPRIO_WHO_PROCESS));
  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_WHO_PGRP",
                   INT2NUM (IOPRIO_WHO_PGRP));
  rb_define_const (rb_mod_ioprio_core_ext_process, "IOPRIO_WHO_USER",
                   INT2NUM (IOPRIO_WHO_USER));

  rb_define_method (rb_mod_ioprio_core_ext_process_class_methods, "ioprio_get",
                    ioprio_get, 2);
  rb_define_method (rb_mod_ioprio_core_ext_process_class_methods, "ioprio_set",
                    ioprio_set, 3);
}
