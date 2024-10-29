module lang::ptl::grammar::Struct

// extend lang::ptl::grammar::SCD;
extend lang::ptl::grammar::Annotations;


syntax Struct
  = @Foldable struct: "struct" EntityId name  StructField+ structFields "end" "struct";

 syntax StructField 
   =  structField: Id  ":"  Type ty
 ;
 

