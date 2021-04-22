//
// author: LiZhiYang
// email: zhiyangleecn@gmail.com
//
#include "php_fontkit.h"
#include "font_php_class.h"
#include "blob_php_class.h"

#ifdef HAVE_WRAP_MEMCPY
extern "C"
{

asm(".symver memcpy, " HAVE_WRAP_MEMCPY);
void *__wrap_memcpy(void *dest, const void *src, size_t n)
{
    return memcpy(dest, src, n);
}

}
#endif

PHP_MINIT_FUNCTION(fontkit)
{
    FONTKIT_STARTUP(font_php_class);
    FONTKIT_STARTUP(blob_php_class);
	return SUCCESS;
}

PHP_MSHUTDOWN_FUNCTION(fontkit)
{
	return SUCCESS;
}

PHP_RINIT_FUNCTION(fontkit)
{
#if defined(COMPILE_DL_FONTKIT) && defined(ZTS)
	ZEND_TSRMLS_CACHE_UPDATE();
#endif
	return SUCCESS;
}

PHP_RSHUTDOWN_FUNCTION(fontkit)
{
	return SUCCESS;
}

PHP_MINFO_FUNCTION(fontkit)
{
	php_info_print_table_start();
	php_info_print_table_header(2, "fontkit support", "enabled");
	php_info_print_table_end();
}

const zend_function_entry fontkit_functions[] = {
	PHP_FE_END
};

zend_module_entry fontkit_module_entry = {
	STANDARD_MODULE_HEADER,
	"fontkit",
	fontkit_functions,
	PHP_MINIT(fontkit),
	PHP_MSHUTDOWN(fontkit),
	PHP_RINIT(fontkit),
	PHP_RSHUTDOWN(fontkit),
	PHP_MINFO(fontkit),
	PHP_FONTKIT_VERSION,
	STANDARD_MODULE_PROPERTIES
};

#ifdef COMPILE_DL_FONTKIT
#ifdef ZTS
ZEND_TSRMLS_CACHE_DEFINE()
#endif
ZEND_GET_MODULE(fontkit)
#endif