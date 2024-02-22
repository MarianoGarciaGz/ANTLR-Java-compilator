
import org.antlr.runtime.*;

public class Test {
    public static void main(String[] args) throws Exception {
        
        ANTLRInputStream input = new ANTLRInputStream(System.in);

        mainLexer lexer = new mainLexer(input);

        CommonTokenStream tokens = new CommonTokenStream(lexer);

        mainParser parser = new mainParser(tokens);
 
        parser.init();
    }
}
