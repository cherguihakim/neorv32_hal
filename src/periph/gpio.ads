with Neorv32; use Neorv32;

package GPIO is
   -- Procédure d'initialisation (optionnelle)
   procedure Init;

   -- Manipulation d'une broche individuelle
   procedure Set_Pin (Pin : Natural);
   function Read_Pin (Pin : Natural) return Boolean;
   function shl (Value  : UInt32; Amount : Natural) return UInt32;


   -- Accès aux registres de sortie complets
   function Get_Output0 return UInt32;
   procedure Set_Output0 (Value : UInt32);
end GPIO;
