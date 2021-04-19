# FontKit-PHP

## Requirement
- PHP 7.1 and later has been tested. 
- Compiler support for C++11 is required

### Install
```
/path/php/bin/phpize
./configure --with-php-config=/path/php/bin/php-config
make && make install
```

## InIs
extension = fontkit.so (windows using : fontkit.dll)

## Methods

```php
$blob = FontKit\Blob::streamRead('./otf_file.otf');
//total font file
$fontIndexSize = $blob->faceCount();
//load first font file
$font = $blob->createFont(0);

$subFont = $font->subset("Test subset words.");
$subFont->streamWrite('./subset.otf');

$blob->destroy();
$font->destroy();
$subFont->destroy();
```
