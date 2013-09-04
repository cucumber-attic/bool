package bool;

import com.google.common.base.Charsets;
import com.google.common.io.Files;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.runners.Parameterized.Parameters;

@RunWith(Parameterized.class)
public class RoundTripTest {

    private final File featureFile;

    @Parameters
    public static Collection<Object[]> data() {
        File rootDir = new File(RoundTripTest.class.getProtectionDomain().getCodeSource().getLocation().getFile())
                .getParentFile()
                .getParentFile()
                .getParentFile();
        File testdata = new File(rootDir, "testdata");
        File good = new File(testdata, "good");
        File[] goodFeatures = good.listFiles();

        List<Object[]> result = new ArrayList<Object[]>();
        for (File goodFeature : goodFeatures) {
            result.add(new Object[]{goodFeature});
        }
        return result;
    }

    public RoundTripTest(File featureFile) {
        this.featureFile = featureFile;
    }

    // See roundtrip_test.js
    @Test
    public void roundtrips_good_features() throws IOException {
        String source = Files.toString(featureFile, Charsets.UTF_8);
        Parser parser = new Parser(new Lexer(source));
        //Feature feature = parser.buildAst();
    }
}
