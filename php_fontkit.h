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

#define fontkit_cxx_php_emalloc(type, size) (static_cast<type *>(emalloc(size)))
#define fontkit_cxx_php_obj_emalloc(type, ce) fontkit_cxx_php_emalloc(type, sizeof(type) + zend_object_properties_size(ce))

#define fontkit_cxx_php_stream_context_from_zval(zcontext, nocontext) static_cast<php_stream_context *>(php_stream_context_from_zval(zcontext, nocontext))

//compatible PHP-7.1 in C++
#if PHP_MAJOR_VERSION == 7 && ((PHP_MINOR_VERSION == 2 && PHP_RELEASE_VERSION < 3) || (PHP_MINOR_VERSION < 2))

#undef ZEND_PARSE_PARAMETERS_START_EX
#define ZEND_PARSE_PARAMETERS_START_EX(flags, min_num_args, max_num_args) do { \
        const int _flags = (flags); \
        int _min_num_args = (min_num_args); \
        int _max_num_args = (max_num_args); \
        int _num_args = EX_NUM_ARGS(); \
        int _i; \
        zval *_real_arg, *_arg = NULL; \
        zend_expected_type _expected_type = Z_EXPECTED_LONG; \
        char *_error = NULL; \
        zend_bool _dummy; \
        zend_bool _optional = 0; \
        int error_code = ZPP_ERROR_OK; \
        ((void)_i); \
        ((void)_real_arg); \
        ((void)_arg); \
        ((void)_expected_type); \
        ((void)_error); \
        ((void)_dummy); \
        ((void)_optional); \
        \
        do { \
            if (UNEXPECTED(_num_args < _min_num_args) || \
                (UNEXPECTED(_num_args > _max_num_args) && \
                 EXPECTED(_max_num_args >= 0))) { \
                if (!(_flags & ZEND_PARSE_PARAMS_QUIET)) { \
                    zend_wrong_parameters_count_error(_flags & ZEND_PARSE_PARAMS_THROW, _num_args, _min_num_args, _max_num_args); \
                } \
                error_code = ZPP_ERROR_FAILURE; \
                break; \
            } \
            _i = 0; \
            _real_arg = ZEND_CALL_ARG(execute_data, 0);

#endif /* #if PHP_MAJOR_VERSION == 7 && ((PHP_MINOR_VERSION == 2 && PHP_RELEASE_VERSION < 3)) */

#endif	/* PHP_FONTKIT_H */
