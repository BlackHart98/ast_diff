module lang::python::utils::Implode


import lang::python::grammar::Parse;
import lang::python::ast::Python;



public Module loadPython(loc location){ 
	getrequirement();
	return parsePythonModule(location);;
}


public Module loadPython(str input, loc src=|unknown:///|){ 
	getrequirement();
	return parsePythonModule(input, src);;
}

bool getrequirement(){
  installRequirements();
  return true;
}