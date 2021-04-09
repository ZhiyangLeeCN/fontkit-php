# FontKit-PHP

## Requirement
- PHP 7 +
- C++11

### Install
```
/use/local/7.xxx/bin/phpize
./configure --with-php-config=/use/local/7.xxx/bin/php-config
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

$blob->destory();
$font->destory();
$subFont->destory();
```
