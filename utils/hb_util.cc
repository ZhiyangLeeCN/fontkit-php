//
// author: LiZhiYang
// email: zhiyangleecn@gmail.com
//

#include "hb_util.h"

//ICU lib include
#include "unicode/utypes.h"
#include "unicode/utext.h"

zend_long hb_set_add_unicode(hb_set_t *codepoints, zend_string *str)
{
    zend_long added = 0;
    UText *ut = NULL;
    UChar32 c = -1;
    UErrorCode status = U_ZERO_ERROR;

    ut = utext_openUTF8(ut, ZSTR_VAL(str), ZSTR_LEN(str), &status);
    if (U_FAILURE(status)) {
        goto error;
    }

    for (c = UTEXT_NEXT32(ut), added = 0; c != U_SENTINEL; c = UTEXT_NEXT32(ut), added++) {
        hb_set_add(codepoints, c);
    }

    error:
    utext_close(ut);
    return added;
}

hb_blob_t *hb_blob_create_from_php_stream(php_stream *stream)
{
    hb_blob_t *blob = NULL;
    zend_string *contents = NULL;
    if ((contents = php_stream_copy_to_mem(stream, PHP_STREAM_COPY_ALL, 0)) != NULL) {
        blob = hb_blob_create(contents->val, contents->len,
                              HB_MEMORY_MODE_READONLY_MAY_MAKE_WRITABLE,
                              contents, (hb_destroy_func_t) zend_string_free);
        if (blob == hb_blob_get_empty()) {
            return NULL;
        } else {
            return blob;
        }
    } else {
        return NULL;
    }
}

hb_blob_t *hb_blob_create_from_php_filename(zend_string *filename, php_stream_context *context)
{
    hb_blob_t *hb_blob = NULL;
    php_stream *stream = php_stream_open_wrapper_ex(ZSTR_VAL(filename), "rb", REPORT_ERRORS, NULL, context);
    if (!stream) {
        return NULL;
    }

    hb_blob = hb_blob_create_from_php_stream(stream);
    php_stream_close(stream);
    return hb_blob;
}

int hb_blob_write_to_php_stream(php_stream *stream, hb_blob_t *hb_blob)
{
    zend_long hb_blob_len = hb_blob_get_length(hb_blob);
    ssize_t numbytes = php_stream_write(stream, hb_blob_get_data(hb_blob, NULL), hb_blob_len);
    if (numbytes != hb_blob_len) {
        php_error_docref(NULL, E_WARNING, "Only %zd of %lld bytes written for font blob, possibly out of free disk space", numbytes, hb_blob_len);
        return FAILURE;
    }
    return SUCCESS;
}
int hb_blob_write_to_php_filename(zend_string *filename, hb_blob_t *hb_blob, php_stream_context *context)
{
    int result;
    php_stream *stream = php_stream_open_wrapper_ex(ZSTR_VAL(filename), "wb", REPORT_ERRORS, NULL, context);
    if (!stream) {
        return FAILURE;
    }

    result = hb_blob_write_to_php_stream(stream, hb_blob);
    php_stream_close(stream);

    return result;
}
