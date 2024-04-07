package internals;
import com.github.gumtreediff.io.TreeIoUtils;
import com.github.gumtreediff.tree.Tree;
import io.usethesource.vallang.IString;
import com.github.gumtreediff.matchers.MappingStore;
import com.github.gumtreediff.matchers.Matcher;
import com.github.gumtreediff.matchers.Matchers;
import com.github.gumtreediff.actions.EditScript;
import com.github.gumtreediff.actions.EditScriptGenerator;
import com.github.gumtreediff.actions.SimplifiedChawatheScriptGenerator;

import io.usethesource.vallang.IValueFactory;

import java.io.*;

public class RascalGumTree {
    private final IValueFactory vf;

    public RascalGumTree (IValueFactory vf) { 
        this.vf = vf;
    }

    Tree generateTree(IString input) throws IOException {
        String input_str = input.getValue();
        if (input_str instanceof String)
            return TreeIoUtils.fromXml().generateFrom().string(input_str).getRoot();
        else
            throw new IllegalArgumentException("Input is not a valid string");
    }


    public final IString compareAST(IString src, IString dst) throws IOException{
        Tree src_tree = generateTree(src);
        Tree dst_tree = generateTree(dst);
        if (src_tree instanceof Tree && dst_tree instanceof Tree){
            Matcher defaultMatcher = Matchers.getInstance().getMatcher();
            MappingStore mappings = defaultMatcher.match(src_tree, dst_tree); 
            EditScript actions = deduceActions(mappings);

            System.out.println(actions); // for debugging purpose

            return vf.string("Hello"); // This is will be replaced with a Rascal compatible object
        } else{
            throw new IllegalArgumentException("Inputs are not valid GumTree AST");
        }
    }

    EditScript deduceActions(MappingStore mappings){
        EditScriptGenerator editScriptGenerator = new SimplifiedChawatheScriptGenerator();
        return editScriptGenerator.computeActions(mappings);
    }
}

