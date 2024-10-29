module lang::yaml::LanguageServer

import ParseTree;

extend analysis::typepal::TypePal;
import util::Reflective;
import util::LanguageServer;
import lang::yaml::grammar::Syntax;
import lang::yaml::checker::Checker;
import Message;
import Prelude;
import IO;

set[LanguageService] yamlContributions() = {
  parser(parser(#start[Document])),
  summarizer(yamlSummarizer, providesImplementations = false)
};

Summary yamlSummarizer(loc l, start[Document] input) {
  pt = parse(#start[Document], l).top;

  TModel model = yamlTModelForTree(input);

  definitions = model.definitions;

  Summary val =  summary(l,
    messages = {<message.at, message> | message <- model.messages},
    references = {<definition, definitions[definition].defined> | definition <- definitions}
  );

  println(val);

  return val;
}

void setupIDE() {
  registerLanguage(
    language(
      pathConfig(srcs = [|std:///|, |project://ptl/src|]),
       "Yaml Grammar",
       "conf",
       "lang::yaml::LanguageServer",
       "yamlContributions"
    )
  );
}