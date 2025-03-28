with Neorv32.GPIO; use Neorv32.GPIO;
with System;
with Interfaces;   use Interfaces;
with GPIO;         use GPIO;

package body GPIO is

   procedure Init is
   begin
   -- Initialisation des registres de sortie
      GPIO_Periph.OUTPUT0 := 16#00000000#;
      GPIO_Periph.OUTPUT1 := 16#00000000#;
      GPIO_Periph.INPUT0 := 2#00000000000000000000000000000000#;
      GPIO_Periph.INPUT1 := 2#00000000000000000000000000000000#;
   end Init;

   function shl (Value  : UInt32; Amount : Natural) return UInt32 is
   begin
      return Value * (2 ** Amount);  -- Décale à gauche en multipliant par 2^Amount
   end shl;

   procedure Set_Pin (Pin : Natural; Value : Pin_Value) is
   begin
      if Pin < 32 then
         if Value = HIGH then
            -- Mettre le pin à high
            GPIO_Periph.OUTPUT0  := GPIO_Periph.OUTPUT0  or (shl(1, Pin));
         else
            -- Mettre le pin à low
            GPIO_Periph.OUTPUT0  := GPIO_Periph.OUTPUT0  and not(shl(1, Pin));
         end if;
      else
         if Value = HIGH then
            -- Mettre le pin à high
            GPIO_Periph.OUTPUT0  := GPIO_Periph.OUTPUT0  or (shl(1, Pin - 32));
         else
            -- Mettre le pin à low
            GPIO_Periph.OUTPUT0  := GPIO_Periph.OUTPUT0  and not(shl(1, Pin - 32));
         end if;
      end if;
   end Set_Pin;


   function Read_Pin (Pin : Natural) return Boolean is
      Value : UInt32;
   begin
      if Pin < 32 then
         Value := GPIO_Periph.INPUT0;
         return (Value and shl(1,Pin)) /= 0;
      else
         Value := GPIO_Periph.INPUT1;
         return (Value and shl(1, Pin - 32)) /= 0;
      end if;
   end Read_Pin;

   function Get_Output0 return UInt32 is
   begin
      return GPIO_Periph.OUTPUT0;
   end Get_Output0;

   procedure Set_Output0 (Value : UInt32) is
   begin
      GPIO_Periph.OUTPUT0 := Value;
   end Set_Output0;

end GPIO;
