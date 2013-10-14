package bool;

import bool.ast.Feature;
import com.google.common.base.Charsets;
import com.google.common.base.Predicate;
import com.google.common.io.Files;
import junitparams.JUnitParamsRunner;
import junitparams.Parameters;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import static com.google.common.collect.Collections2.filter;
import static org.junit.Assert.assertEquals;

/**
 * This test parses feature files under /testdata/good, renders them and verifies that the output
 * is the same as the input.
 *
 * To validate just a single file, run with FEATURE=filename
 */
@RunWith(JUnitParamsRunner.class)
public class RoundTripTest {
    private static String FEATURE_PATTERN = System.getenv().get("FEATURE");

    static {
        if (FEATURE_PATTERN == null) {
            FEATURE_PATTERN = ".*";
        } else {
            FEATURE_PATTERN = ".*" + FEATURE_PATTERN + ".*";
        }
    }

    public static Object[] featureFiles() {
        File rootDir = new File(RoundTripTest.class.getProtectionDomain().getCodeSource().getLocation().getFile())
                .getParentFile()
                .getParentFile()
                .getParentFile();
        File testdata = new File(rootDir, "testdata");
        File good = new File(testdata, "good");
        List<File> goodFeatures = Arrays.asList(good.listFiles());
        Collection<File> filteredGoodFeatures = filter(goodFeatures, new Predicate<File>() {
            @Override
            public boolean apply(File file) {
                return file.getPath().matches(FEATURE_PATTERN);
            }
        });
        return filteredGoodFeatures.toArray();
    }

    @Test
    @Parameters(method = "featureFiles")
    public void roundtrips_good_features(File featureFile) throws IOException {
        String source = Files.toString(featureFile, Charsets.UTF_8);
        Parser parser = new Parser(new Lexer(source));
        try {
            Feature feature = parser.buildAst();
            String rendered = new Renderer().render(feature);
            assertEquals(source, rendered);
        } catch (SyntaxError e) {
            StackTraceElement[] stackTrace = e.getStackTrace();
            stackTrace[stackTrace.length - 1] = new StackTraceElement(getClass().getName(), "roundtrips_good_features", featureFile.getName(), e.getFirstLine());
            e.setStackTrace(stackTrace);
            throw e;
        }
    }
}
