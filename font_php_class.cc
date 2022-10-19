//
// author: LiZhiYang
// email: zhiyangleecn@gmail.com
//

#include "font_php_class.h"

zend_class_entry *font_ce;
zend_object_handlers font_object_handlers;

ZEND_BEGIN_ARG_INFO_EX(arginfo_font_construct, 0, 0, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_font_subset, 0, 0, 1)
    ZEND_ARG_TYPE_INFO(0, "text", IS_STRING, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_font_get_data, 0, 0, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_font_stream_write, 0, 0, 1)
    ZEND_ARG_TYPE_INFO(0, "filename", IS_STRING, 0)
    ZEND_ARG_TYPE_INFO(0, "context", IS_RESOURCE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_font_destory, 0, 0, 0)
ZEND_END_ARG_INFO()

PHP_METHOD(Font, __construct)
{

}

PHP_METHOD(Font, subset)
{
    zend_string *text = NULL;
    font_php_object *font_php_obj = NULL;
    zend_object *sub_font_obj = NULL;
    font_php_object *sub_font_php_obj = NULL;
    hb_face_t *src_hb_face = NULL;
    hb_face_t *dst_hb_face = NULL;
    hb_font_t *dst_hb_font = NULL;
    hb_subset_input_t *sub_input = NULL;
    hb_set_t *sub_unicode_input = NULL;
    hb_set_t *drop_table_set = NULL;

    ZEND_PARSE_PARAMETERS_START(1,1)
        Z_PARAM_STR(text)
    ZEND_PARSE_PARAMETERS_END();

    font_php_obj = php_font_fetch_object(Z_OBJ_P(getThis()));
    src_hb_face = font_php_obj->face;

    sub_input = hb_subset_input_create_or_fail();
    drop_table_set = hb_subset_input_drop_tables_set(sub_input);
    hb_set_del(drop_table_set, HB_TAG ('G','S','U','B'));
    hb_set_del(drop_table_set, HB_TAG('G', 'P', 'O', 'S'));
    hb_set_del(drop_table_set, HB_TAG('G', 'D', 'E', 'F'));
    sub_unicode_input = hb_subset_input_unicode_set(sub_input);
    hb_set_add_unicode(sub_unicode_input, text);

    dst_hb_face = hb_subset(src_hb_face, sub_input);
    hb_subset_input_destroy(sub_input);
    if (dst_hb_face == hb_face_get_empty()) {
        RETURN_FALSE;
    } else {
        dst_hb_font = hb_font_create(dst_hb_face);
        if (dst_hb_font == hb_font_get_empty()) {
            hb_face_destroy(dst_hb_face);
            RETURN_FALSE;
        } else {
            sub_font_obj = php_font_object_new(font_ce);
            sub_font_php_obj = php_font_fetch_object(sub_font_obj);
            sub_font_php_obj->face = dst_hb_face;
            sub_font_php_obj->font = dst_hb_font;
            RETURN_OBJ(sub_font_obj);
        }
    }
}

PHP_METHOD(Font, getData)
{
    font_php_object *font_php_obj = php_font_fetch_object(Z_OBJ_P(getThis()));
    hb_blob_t *hb_blob = hb_face_reference_blob(font_php_obj->face);
    zend_long hb_blob_len = hb_blob_get_length(hb_blob);
    zend_string *data = NULL;

    data = zend_string_alloc(hb_blob_len + 1, 0);
    memcpy(ZSTR_VAL(data), hb_blob_get_data(hb_blob, NULL), hb_blob_len);
    ZSTR_LEN(data) = hb_blob_len;
    ZSTR_VAL(data)[hb_blob_len] = '\0';
    hb_blob_destroy(hb_blob);

    RETURN_STR(data);
}

PHP_METHOD(Font, streamWrite)
{
    zend_string *filename;
    int result;
    zval *zcontext = NULL;
    hb_blob_t *hb_blob = NULL;
    font_php_object *font_php_obj = NULL;
    php_stream_context *context = NULL;

    ZEND_PARSE_PARAMETERS_START(1, 2)
        Z_PARAM_STR(filename)
        Z_PARAM_OPTIONAL
        Z_PARAM_RESOURCE_EX(zcontext, 1, 0)
    ZEND_PARSE_PARAMETERS_END();

    context = fontkit_cxx_php_stream_context_from_zval(zcontext, PHP_FILE_NO_DEFAULT_CONTEXT);
    font_php_obj = php_font_fetch_object(Z_OBJ_P(getThis()));
    hb_blob = hb_face_reference_blob(font_php_obj->face);

    result = hb_blob_write_to_php_filename(filename, hb_blob, context);
    if (result == SUCCESS) {
        RETURN_TRUE;
    } else {
        RETURN_FALSE;
    }
}

PHP_METHOD(Font, destroy)
{
    font_php_object *font_php_obj = php_font_fetch_object(Z_OBJ_P(getThis()));
    php_font_resource_free(font_php_obj);
    RETURN_TRUE;
}

static const zend_function_entry font_php_class_methods[] = {
        PHP_ME(Font, __construct, arginfo_font_construct, ZEND_ACC_PRIVATE | ZEND_ACC_CTOR)
        PHP_ME(Font, subset, arginfo_font_subset, ZEND_ACC_PUBLIC)
        PHP_ME(Font, getData, arginfo_font_get_data, ZEND_ACC_PUBLIC)
        PHP_ME(Font, streamWrite, arginfo_font_stream_write, ZEND_ACC_PUBLIC)
        PHP_ME(Font, destroy, arginfo_font_destory, ZEND_ACC_PUBLIC)
        PHP_FE_END
};

zend_object *php_font_object_new(zend_class_entry *ce)
{
    font_php_object *font_object = fontkit_cxx_php_obj_emalloc(font_php_object, ce);

    zend_object_std_init(&font_object->std, ce);
    object_properties_init(&font_object->std, ce);
    font_object->std.handlers = &font_object_handlers;

    font_object->face = NULL;
    font_object->font = NULL;

    return &font_object->std;
}

void php_font_object_free(zend_object *object)
{
    font_php_object *font_php_object = php_font_fetch_object(object);
    php_font_resource_free(font_php_object);
    zend_object_std_dtor(&font_php_object->std);
}

void php_font_resource_free(font_php_object *font_php_object)
{
    if (font_php_object->font != NULL) {
        hb_font_destroy(font_php_object->font);
    }

    if (font_php_object->face != NULL) {
        hb_face_destroy(font_php_object->face);
    }

    font_php_object->font = NULL;
    font_php_object->face = NULL;
}

FONTKIT_STARTUP_FUNCTION(font_php_class)
{
    zend_class_entry ce;

    font_object_handlers = std_object_handlers;
    font_object_handlers.offset = XtOffsetOf(font_php_object, std);
    font_object_handlers.free_obj = php_font_object_free;

    FONTKIT_INIT_CLASS_ENTRY(ce, "Font", font_php_class_methods)
    font_ce = zend_register_internal_class(&ce);
    font_ce->create_object = php_font_object_new;

    return SUCCESS;
}