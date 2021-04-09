//
// author: LiZhiYang
// email: zhiyangleecn@gmail.com
//

#ifndef PHP_FONTKIT_FONT_PHP_CLASS_H
#define PHP_FONTKIT_FONT_PHP_CLASS_H

#include "php_fontkit.h"

extern zend_class_entry *font_ce;

typedef struct {
    hb_face_t   *face;
    hb_font_t   *font;
    zend_object std;
} font_php_object;

zend_object *php_font_object_new(zend_class_entry *ce);
void php_font_object_free(zend_object *object);
void php_font_resource_free(font_php_object *font_php_object);

static inline font_php_object *php_font_fetch_object(zend_object *object)
{
    return (font_php_object *)((char*)(object) - XtOffsetOf(font_php_object, std));
}

FONTKIT_STARTUP_FUNCTION(font_php_class);

#endif //PHP_FONTKIT_FONT_PHP_CLASS_H
