//
// author: LiZhiYang
// email: zhiyangleecn@gmail.com
//

#ifndef PHP_FONTKIT_BLOB_PHP_CLASS_H
#define PHP_FONTKIT_BLOB_PHP_CLASS_H

#include "php_fontkit.h"

extern zend_class_entry *blob_ce;

typedef struct {
    hb_blob_t   *blob;
    zend_object std;
} blob_php_object;

zend_object *php_blob_object_new(zend_class_entry *ce);
void php_blob_object_free(zend_object *object);
void php_blob_resource_free(blob_php_object *blob_php_object);

static inline blob_php_object *php_blob_fetch_object(zend_object *object)
{
    return (blob_php_object *)((char*)(object) - XtOffsetOf(blob_php_object, std));
}

FONTKIT_STARTUP_FUNCTION(blob_php_class);


#endif //PHP_FONTKIT_BLOB_PHP_CLASS_H
