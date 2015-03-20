defmodule ESpec.Assertion do

  use Behaviour

  defcallback assert(act :: Type::any, exp :: Type::any, positive :: Type.atom) :: Type.atom
  defcallback success?(act :: Type::any, exp :: Type::any, positive :: Type.atom) :: Type.atom
  defcallback error_message(act :: Type::any, exp :: Type::any, positive :: Type.atom) :: Type.Bitstring


end
