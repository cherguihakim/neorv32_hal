with neorv32; use neorv32;

package Random is
   procedure Init;
   function Random return Byte;
end Random;