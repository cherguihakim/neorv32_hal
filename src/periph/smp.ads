with Interrupts; use Interrupts;
with neorv32; use neorv32;

package SMP is
subtype SMP_T is Integer range -2 .. 0;
type Function_T is access procedure;
type Byte_T is access all Byte;
   function smp_launch(Entry_Point : Function_T; Stack_Memory : Byte_T; Stack_Size : UInt32 ) return SMP_T;
   function smp_get_hart_id return Harts_T;
end SMP;