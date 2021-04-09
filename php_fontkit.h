//
// author: LiZhiYang
// email: zhiyangleecn@gmail.com
//

#ifndef PHP_FONTKIT_H
#define PHP_FONTKIT_H

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "php_streams.h"
#include "ext/standard/file.h"
#include "ext/standard/info.h"

#include "utils/icu_util.h"
#include "utils/hb_util.h"

extern zend_module_entry fontkit_module_entry;
#define phpext_fontkit_ptr &fontkit_module_entry

#define PHP_FONTKIT_VERSION "0.1.0"

#ifdef PHP_WIN32
#	define PHP_FONTKIT_API __declspec(dllexport)
#elif defined(__GNUC__) && __GNUC__ >= 4
#	define PHP_FONTKIT_API __attribute__ ((visibility("default")))
#else
#	define PHP_FONTKIT_API
#endif

#ifdef ZTS
#include "TSRM.h"
#endif

#if defined(ZTS) && defined(COMPILE_DL_FONTKIT)
ZEND_TSRMLS_CACHE_EXTERN()
#endif

#define FONTKIT_STARTUP_FUNCTION(module)    ZEND_MINIT_FUNCTION(tess_##module)
#define FONTKIT_RINIT_FUNCTION(module)	    ZEND_RINIT_FUNCTION(tess_##module)
#define FONTKIT_STARTUP(module)             ZEND_MODULE_STARTUP_N(tess_##module)(INIT_FUNC_ARGS_PASSTHRU)
#define FONTKIT_SHUTDOWN_FUNCTION(module)   ZEND_MSHUTDOWN_FUNCTION(tess_##module)
#define FONTKIT_SHUTDOWN(module)            ZEND_MODULE_SHUTDOWN_N(tess_##module)(INIT_FUNC_ARGS_PASSTHRU)

#define FONTKIT_INIT_CLASS_ENTRY(ce, name, methods) INIT_CLASS_ENTRY(ce, ZEND_NS_NAME("FontKit", name), methods)

#endif	/* PHP_FONTKIT_H */
