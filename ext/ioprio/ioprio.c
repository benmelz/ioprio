#include "ioprio.h"

VALUE rb_mIoprio;

RUBY_FUNC_EXPORTED void
Init_ioprio (void)
{
  rb_mIoprio = rb_define_module ("Ioprio");
}
