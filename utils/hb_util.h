//
// author: LiZhiYang
// email: zhiyangleecn@gmail.com
//

#ifndef PHP_FONTKIT_UTILS_HB_H
#define PHP_FONTKIT_UTILS_HB_H

#include "c_wrapper.h"

//harfbuzz lib include
#include "hb.h"
#include "hb-ot.h"
#include "hb-subset.h"


FONTKIT_C_API_WRAPPER_BEGIN()

zend_long hb_set_add_unicode(hb_set_t *codepoints, zend_string *str);
hb_blob_t *hb_blob_create_from_php_stream(php_stream *stream);
hb_blob_t *hb_blob_create_from_php_filename(zend_string *filename, php_stream_context *context);
zend_bool hb_blob_write_to_php_stream(php_stream *stream, hb_blob_t *hb_blob);
zend_bool hb_blob_write_to_php_filename(zend_string *filename, hb_blob_t *hb_blob, php_stream_context *context);

FONTKIT_C_API_WRAPPER_END()


#endif //PHP_FONTKIT_UTILS_HB_H
