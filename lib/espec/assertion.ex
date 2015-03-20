defmodule ESpec.Assertion do

  use Behaviour

  defcallback assert(act :: Type::any, exp :: Type::any, positive :: Type.atom) :: Type.atom


end
