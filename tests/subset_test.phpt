--TEST--
Test font subset from local font file.
--FILE--
<?php
function subset($filePath, $text, $outfilePath)
{
    $blob = null;
    $font = null;
    $subFont = null;

    try {

        $blob = FontKit\Blob::streamRead($filePath);
        if (false === $blob) {
            throw new Exception("{$filePath} read failed.");
        }

        $faceCount = $blob->faceCount();
        if ($faceCount <= 0) {
            throw new Exception("get wrong face count[{$faceCount}] from {$filePath}");
        }

        $index = 0;
        $font = $blob->createFont($index);
        if (false === $font) {
            throw new Exception("create font[index:{$index}] failed from blob[{$filePath}].");
        }

        $subFont = $font->subset($text);
        if (false === $subFont) {
            throw new Exception("font[index:{$index}] subset[text:{$text}] failed.");
        }

        if (false === $subFont->streamWrite($outfilePath)) {
            throw new Exception("stream write sub font data to {$outfilePath} failed.");
        }

        echo "success\n";

    } catch (\Exception $e) {
        echo $e->getMessage() . "\n";
    } finally {
        if ($blob) {
            $blob->destroy();
        }
        if ($font) {
            $font->destroy();
        }
        if ($subFont) {
            $subFont->destroy();
        }
    }
}

$text = '【春a1】';

@mkdir('./tests/tmp_out/');

subset('./tests/fonts/test_002.ttf', $text, './tests/tmp_out/hb_subset_002.ttf');
@unlink('./tests/tmp_out/hb_subset_002.ttf');

subset('./tests/fonts/test_001.otf', $text, './tests/tmp_out/hb_subset_001.otf');
@unlink('./tests/tmp_out/hb_subset_001.otf');

@rmdir('./tests/tmp_out/');

--EXPECT--
success
success
