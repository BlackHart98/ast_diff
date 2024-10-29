module lib::Test
import lib::Functools;

test bool testBuildReportTranslationError (){
  map[str, value] expected_error_result = ("message":"Translation error","error":("summary":"message: View Field  not resolved","location":|unknown:///act_sales.ptl|),"status":"error");
  Result[&U] result = error(<"Translation error",TranslationException("message: View Field  not resolved",|unknown:///act_sales.ptl|)>);
  output = buildReport(result);
  assert output["message"] == expected_error_result["message"]: "error message has to be the same as output";
  assert output["error"] == expected_error_result["error"]: "error body has to be the same as output";
  assert output["status"] == expected_error_result["status"]: "status has to be the same as output";
  return true;
}

test bool testBuildReportToStringError (){
  map[str, value] expected_error_result = ("message":"Translation error","error":("summary":"message: View Field  not resolved","location":|unknown:///act_sales.ptl|),"status":"error");
  Result[&U] result = error(<"Translation error",ToStringException("message: View Field  not resolved",|unknown:///act_sales.ptl|)>);
  output = buildReport(result);

  assert output["message"] == expected_error_result["message"]: "error message has to be the same as output";
  assert output["status"] == expected_error_result["status"]: "status has to be the same as output";
  assert output["error"] == expected_error_result["error"]: "error body has to be the same as output";
  
  return true;
}

test bool testBuildReportSuccess(){
    map[str, value] expected_success_result = ("message":"build successful.","status":"success");
    result = ok([<|project://adept-base/examples|, "some content">]);
    output = buildReport(result);
    assert output["message"] == expected_success_result["message"]: "success message has to be the same as output";
    assert output["status"] == expected_success_result["status"]: "status has to be the same as output";
    return true;
}