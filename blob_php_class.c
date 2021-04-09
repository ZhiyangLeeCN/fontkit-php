//
// author: LiZhiYang
// email: zhiyangleecn@gmail.com
//

#include "blob_php_class.h"
#include "font_php_class.h"

zend_class_entry *blob_ce;
zend_object_handlers blob_object_handlers;

ZEND_BEGIN_ARG_INFO_EX(arginfo_blob_construct, 0, 0, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_blob_stream_read, 0, 0, 1)
    ZEND_ARG_TYPE_INFO(0, "filename", IS_STRING, 0)
    ZEND_ARG_TYPE_INFO(0, "context", IS_RESOURCE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_blob_face_count, 0, 0, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_blob_createFont, 0, 0, 1)
    ZEND_ARG_TYPE_INFO(0, "face_index", IS_LONG, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_blob_destory, 0, 0, 0)
ZEND_END_ARG_INFO()

PHP_METHOD(Blob, __construct)
{

}

PHP_METHOD(Blob, streamRead)
{
    zend_string *filename = NULL;
    zval *zcontext = NULL;
    zend_object *blob_object = NULL;
    php_stream_context *context = NULL;
    blob_php_object *blob_php_object = NULL;

    ZEND_PARSE_PARAMETERS_START(1,2)
        Z_PARAM_STR(filename)
        Z_PARAM_OPTIONAL
        Z_PARAM_RESOURCE_EX(zcontext, 1, 0)
    ZEND_PARSE_PARAMETERS_END();

    context = php_stream_context_from_zval(zcontext, 0);
    hb_blob_t *blob = hb_blob_create_from_php_filename(filename, context);
    if (!blob) {
        php_error_docref(NULL, E_WARNING, "Failed to read font data from \"%s\"", ZSTR_VAL(filename));
        RETURN_FALSE;
    }

    blob_object = php_blob_object_new(blob_ce);
    blob_php_object = php_blob_fetch_object(blob_object);
    blob_php_object->blob = blob;

    RETURN_OBJ(blob_object)
}

PHP_METHOD(Blob, faceCount)
{
    blob_php_object *blob_php_object = php_blob_fetch_object(Z_OBJ_P(getThis()));
    zend_long count = hb_face_count(blob_php_object->blob);
    RETURN_LONG(count)
}

PHP_METHOD(Blob, createFont)
{
    zend_long index = 0;
    zend_object *font_object = NULL;
    hb_face_t *hb_face = NULL;
    hb_font_t *hb_font = NULL;
    blob_php_object *blob_php_object = NULL;
    font_php_object *font_php_object = NULL;

    ZEND_PARSE_PARAMETERS_START(1, 1)
        Z_PARAM_LONG(index)
    ZEND_PARSE_PARAMETERS_END();

    blob_php_object = php_blob_fetch_object(Z_OBJ_P(getThis()));

    hb_face = hb_face_create(blob_php_object->blob, index);
    if (hb_face == hb_face_get_empty()) {
        php_error_docref(NULL, E_WARNING, "Failed to create font face.");
        RETURN_FALSE
    }

    hb_font = hb_font_create(hb_face);
    if (hb_font == hb_font_get_empty()) {
        hb_face_destroy(hb_face);
        php_error_docref(NULL, E_WARNING, "Failed to create font.");
        RETURN_FALSE
    }

    font_object = php_font_object_new(font_ce);
    font_php_object = php_font_fetch_object(font_object);
    font_php_object->face = hb_face;
    font_php_object->font = hb_font;

    RETURN_OBJ(font_object)
}

PHP_METHOD(Blob, destory)
{
    blob_php_object *blob_php_object = php_blob_fetch_object(Z_OBJ_P(getThis()));
    php_blob_resource_free(blob_php_object);
    RETURN_TRUE
}

static const zend_function_entry blob_php_class_methods[] = {
        PHP_ME(Blob, __construct, arginfo_blob_construct, ZEND_ACC_PRIVATE | ZEND_ACC_CTOR)
        PHP_ME(Blob, streamRead, arginfo_blob_stream_read, ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
        PHP_ME(Blob, faceCount, arginfo_blob_face_count, ZEND_ACC_PUBLIC)
        PHP_ME(Blob, createFont, arginfo_blob_createFont, ZEND_ACC_PUBLIC)
        PHP_ME(Blob, destory, arginfo_blob_destory, ZEND_ACC_PUBLIC)
        PHP_FE_END
};

zend_object *php_blob_object_new(zend_class_entry *ce)
{
    blob_php_object *font_object = emalloc(sizeof(blob_php_object) + zend_object_properties_size(ce));

    zend_object_std_init(&font_object->std, ce);
    object_properties_init(&font_object->std, ce);
    font_object->std.handlers = &blob_object_handlers;

    font_object->blob = NULL;

    return &font_object->std;
}

void php_blob_object_free(zend_object *object)
{
    blob_php_object *blob_php_object = php_blob_fetch_object(object);
    zend_object_std_dtor(&blob_php_object->std);
    php_blob_resource_free(blob_php_object);
    efree(blob_php_object);
}

void php_blob_resource_free(blob_php_object *blob_php_object)
{
    if (blob_php_object->blob != NULL) {
        hb_blob_destroy(blob_php_object->blob);
    }

    blob_php_object->blob = NULL;
}

FONTKIT_STARTUP_FUNCTION(blob_php_class)
{
    zend_class_entry ce;

    blob_object_handlers = std_object_handlers;
    blob_object_handlers.offset = XtOffsetOf(blob_php_object, std);
    blob_object_handlers.free_obj = php_blob_object_free;

    FONTKIT_INIT_CLASS_ENTRY(ce, "Blob", blob_php_class_methods)
    blob_ce = zend_register_internal_class(&ce);
    blob_ce->create_object = php_blob_object_new;

    return SUCCESS;
}
