with RISCV.CSR;
with neorv32; use neorv32;

package body SMP is 
   function smp_launch(Entry_Point : Function_T; Stack_Memory : Byte_T; Stack_Size : UInt32 ) return SMP_T is 
   begin 
      return 0;
   end smp_launch;

   function smp_get_hart_id return Harts_T is
   begin
      return Harts_T (RISCV.CSR.MHARTID.Read);
   end smp_get_hart_id;

end SMP;