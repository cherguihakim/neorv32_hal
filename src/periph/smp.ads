with Interrupts; use Interrupts;
with neorv32; use neorv32;

package SMP is
   subtype SMP_T is Integer range -2 .. 0;
   type Function_T is access procedure; -- function pointer (*function)(void)
   type Stack_T is array (0 .. 2048 - 1) of Byte;
   type Stack_Ptr is access all Stack_T;
   function smp_launch(Entry_Point : Function_T; Stack_Memory : Stack_T) return SMP_T;
   function smp_get_hart_id return Harts_T;
end SMP;