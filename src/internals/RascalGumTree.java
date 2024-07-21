package internals;

import com.github.gumtreediff.io.ActionsIoUtils;
import com.github.gumtreediff.io.TreeIoUtils;
import com.github.gumtreediff.tree.Tree;
import com.github.gumtreediff.tree.TreeContext;
import io.usethesource.vallang.IString;
import com.github.gumtreediff.matchers.MappingStore;

import com.github.gumtreediff.actions.EditScript;
import com.github.gumtreediff.actions.EditScriptGenerator;
import com.github.gumtreediff.actions.ChawatheScriptGenerator;
import io.usethesource.vallang.IValueFactory;
import com.github.gumtreediff.matchers.optimal.zs.ZsMatcher;



import java.io.*;

public class RascalGumTree {
    private final IValueFactory vf;

    public RascalGumTree (IValueFactory vf) { 
        this.vf = vf;
    }

    TreeContext generateTree(IString input) throws IOException {
        String input_str = input.getValue();
        if (input_str instanceof String)
            return TreeIoUtils.fromXml().generateFrom().string(input_str);
        else
            throw new IllegalArgumentException("Input is not a valid string");
    }


    public final IString compareAST(IString src, IString dst) throws IOException{
        TreeContext src_ctx = generateTree(src);
        TreeContext dst_ctx = generateTree(dst);
        if (src_ctx.getRoot() instanceof Tree && dst_ctx.getRoot() instanceof Tree){
            MappingStore mappings = new ZsMatcher().match(src_ctx.getRoot(), dst_ctx.getRoot());
            EditScript actions = deduceActions(mappings);
            return vf.string(ActionsIoUtils.toJson(src_ctx, actions, mappings).toString()); // This is will be replaced with a Rascal compatible object
        } else{
            throw new IllegalArgumentException("Inputs are not valid GumTree AST");
        }
    }

    public final IString compareASTXml(IString src, IString dst) throws IOException{
        TreeContext src_ctx = generateTree(src);
        TreeContext dst_ctx = generateTree(dst);
        if (src_ctx.getRoot() instanceof Tree && dst_ctx.getRoot() instanceof Tree){
            MappingStore mappings = new ZsMatcher().match(src_ctx.getRoot(), dst_ctx.getRoot());
            EditScript actions = deduceActions(mappings);
            return vf.string(ActionsIoUtils.toXml(src_ctx, actions, mappings).toString()); // This is will be replaced with a Rascal compatible object
        } else{
            throw new IllegalArgumentException("Inputs are not valid GumTree AST");
        }
    }

    private EditScript deduceActions(MappingStore mappings){
        EditScriptGenerator editScriptGenerator = new ChawatheScriptGenerator();
        return editScriptGenerator.computeActions(mappings);
    }

    // private String toJsonRascal(TreeContext src_ctx, EditScript actions, MappingStore mappings){

    //     return "";
    // }

}
