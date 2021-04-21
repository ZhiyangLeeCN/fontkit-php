PHP_ARG_WITH(fontkit, for fontkit support,
[  --with-fontkit             Include fontkit support])

PHP_ARG_ENABLE(wrap-glibc-memcpy, wrap memcpy,
[  --enable-wrap-glibc-memcpy         Wrap memcpy for specify libgcc version(Only linux can using)], no, no)

PHP_ARG_ENABLE(cxx-shared-module, enable C++ shared module is desired,
[  --enable-cxx-shared-module        Enable C++ shared module is desired], yes, no)

if test "$PHP_FONTKIT" != "no"; then

  AS_CASE([$host_os],
     [darwin*], [FTK_OS="MAC"],
     [cygwin*], [FTK_OS="CYGWIN"],
     [mingw*], [FTK_OS="MINGW"],
     [linux*], [FTK_OS="LINUX"],
     []
  )

  if test "$PHP_WRAP_GLIBC_MEMCPY" != "no"; then
    LDFLAGS="$LDFLAGS -Wl,--wrap=memcpy"
    AC_DEFINE_UNQUOTED([HAVE_WRAP_MEMCPY], ["$PHP_WRAP_GLIBC_MEMCPY"], [Need wrap memcpy function])
    AC_MSG_RESULT([$PHP_WRAP_GLIBC_MEMCPY])
  fi

  PHP_REQUIRE_CXX()
  m4_ifndef([PHP_CXX_COMPILE_STDCXX], [m4_include([php_cxx_compile_stdcxx.m4])])

  AC_MSG_CHECKING([if compiling with clang])
    AC_COMPILE_IFELSE([
        AC_LANG_PROGRAM([], [[
            #ifndef __clang__
                not clang
            #endif
        ]])],
        [CLANG=yes], [CLANG=no]
    )
  AC_MSG_RESULT([$CLANG])

  PHP_ADD_INCLUDE([]PHP_EXT_DIR(fontkit))
  PHP_ADD_INCLUDE(third_party/harfbuzz-ng/src)
  PHP_ADD_INCLUDE(third_party/icu/source/common)
  PHP_ADD_INCLUDE(third_party/icu/source/i18n)

  LIB_ICU_SOURCES="third_party/icu/source/stubdata/stubdata.cpp third_party/icu/source/common/appendable.cpp third_party/icu/source/common/bmpset.cpp \
      third_party/icu/source/common/brkeng.cpp third_party/icu/source/common/brkiter.cpp \
      third_party/icu/source/common/bytesinkutil.cpp third_party/icu/source/common/bytestream.cpp \
      third_party/icu/source/common/bytestrie.cpp third_party/icu/source/common/bytestriebuilder.cpp \
      third_party/icu/source/common/bytestrieiterator.cpp third_party/icu/source/common/caniter.cpp \
      third_party/icu/source/common/characterproperties.cpp third_party/icu/source/common/chariter.cpp \
      third_party/icu/source/common/charstr.cpp third_party/icu/source/common/cmemory.cpp \
      third_party/icu/source/common/cstr.cpp third_party/icu/source/common/cstring.cpp \
      third_party/icu/source/common/cwchar.cpp third_party/icu/source/common/dictbe.cpp \
      third_party/icu/source/common/dictionarydata.cpp third_party/icu/source/common/dtintrv.cpp \
      third_party/icu/source/common/edits.cpp third_party/icu/source/common/errorcode.cpp \
      third_party/icu/source/common/filteredbrk.cpp third_party/icu/source/common/filterednormalizer2.cpp \
      third_party/icu/source/common/icudataver.cpp third_party/icu/source/common/icuplug.cpp \
      third_party/icu/source/common/loadednormalizer2impl.cpp third_party/icu/source/common/localebuilder.cpp \
      third_party/icu/source/common/localematcher.cpp third_party/icu/source/common/localeprioritylist.cpp \
      third_party/icu/source/common/locavailable.cpp third_party/icu/source/common/locbased.cpp \
      third_party/icu/source/common/locdispnames.cpp third_party/icu/source/common/locdistance.cpp \
      third_party/icu/source/common/locdspnm.cpp third_party/icu/source/common/locid.cpp \
      third_party/icu/source/common/loclikely.cpp third_party/icu/source/common/loclikelysubtags.cpp \
      third_party/icu/source/common/locmap.cpp third_party/icu/source/common/locresdata.cpp \
      third_party/icu/source/common/locutil.cpp third_party/icu/source/common/lsr.cpp \
      third_party/icu/source/common/messagepattern.cpp third_party/icu/source/common/normalizer2.cpp \
      third_party/icu/source/common/normalizer2impl.cpp third_party/icu/source/common/normlzr.cpp \
      third_party/icu/source/common/parsepos.cpp third_party/icu/source/common/patternprops.cpp \
      third_party/icu/source/common/pluralmap.cpp third_party/icu/source/common/propname.cpp \
      third_party/icu/source/common/propsvec.cpp third_party/icu/source/common/punycode.cpp \
      third_party/icu/source/common/putil.cpp third_party/icu/source/common/rbbi.cpp \
      third_party/icu/source/common/rbbi_cache.cpp third_party/icu/source/common/rbbidata.cpp \
      third_party/icu/source/common/rbbinode.cpp third_party/icu/source/common/rbbirb.cpp \
      third_party/icu/source/common/rbbiscan.cpp third_party/icu/source/common/rbbisetb.cpp \
      third_party/icu/source/common/rbbistbl.cpp third_party/icu/source/common/rbbitblb.cpp \
      third_party/icu/source/common/resbund.cpp third_party/icu/source/common/resbund_cnv.cpp \
      third_party/icu/source/common/resource.cpp third_party/icu/source/common/restrace.cpp \
      third_party/icu/source/common/ruleiter.cpp third_party/icu/source/common/schriter.cpp \
      third_party/icu/source/common/serv.cpp third_party/icu/source/common/servlk.cpp \
      third_party/icu/source/common/servlkf.cpp third_party/icu/source/common/servls.cpp \
      third_party/icu/source/common/servnotf.cpp third_party/icu/source/common/servrbf.cpp \
      third_party/icu/source/common/servslkf.cpp third_party/icu/source/common/sharedobject.cpp \
      third_party/icu/source/common/simpleformatter.cpp third_party/icu/source/common/static_unicode_sets.cpp \
      third_party/icu/source/common/stringpiece.cpp third_party/icu/source/common/stringtriebuilder.cpp \
      third_party/icu/source/common/uarrsort.cpp third_party/icu/source/common/ubidi.cpp \
      third_party/icu/source/common/ubidi_props.cpp third_party/icu/source/common/ubidiln.cpp \
      third_party/icu/source/common/ubiditransform.cpp third_party/icu/source/common/ubidiwrt.cpp \
      third_party/icu/source/common/ubrk.cpp third_party/icu/source/common/ucase.cpp \
      third_party/icu/source/common/ucasemap.cpp third_party/icu/source/common/ucasemap_titlecase_brkiter.cpp \
      third_party/icu/source/common/ucat.cpp third_party/icu/source/common/uchar.cpp \
      third_party/icu/source/common/ucharstrie.cpp third_party/icu/source/common/ucharstriebuilder.cpp \
      third_party/icu/source/common/ucharstrieiterator.cpp third_party/icu/source/common/uchriter.cpp \
      third_party/icu/source/common/ucln_cmn.cpp third_party/icu/source/common/ucmndata.cpp \
      third_party/icu/source/common/ucnv.cpp third_party/icu/source/common/ucnv2022.cpp \
      third_party/icu/source/common/ucnv_bld.cpp third_party/icu/source/common/ucnv_cb.cpp \
      third_party/icu/source/common/ucnv_cnv.cpp third_party/icu/source/common/ucnv_ct.cpp \
      third_party/icu/source/common/ucnv_err.cpp third_party/icu/source/common/ucnv_ext.cpp \
      third_party/icu/source/common/ucnv_io.cpp third_party/icu/source/common/ucnv_lmb.cpp \
      third_party/icu/source/common/ucnv_set.cpp third_party/icu/source/common/ucnv_u16.cpp \
      third_party/icu/source/common/ucnv_u32.cpp third_party/icu/source/common/ucnv_u7.cpp \
      third_party/icu/source/common/ucnv_u8.cpp third_party/icu/source/common/ucnvbocu.cpp \
      third_party/icu/source/common/ucnvdisp.cpp third_party/icu/source/common/ucnvhz.cpp \
      third_party/icu/source/common/ucnvisci.cpp third_party/icu/source/common/ucnvlat1.cpp \
      third_party/icu/source/common/ucnvmbcs.cpp third_party/icu/source/common/ucnvscsu.cpp \
      third_party/icu/source/common/ucnvsel.cpp third_party/icu/source/common/ucol_swp.cpp \
      third_party/icu/source/common/ucptrie.cpp third_party/icu/source/common/ucurr.cpp \
      third_party/icu/source/common/udata.cpp third_party/icu/source/common/udatamem.cpp \
      third_party/icu/source/common/udataswp.cpp third_party/icu/source/common/uenum.cpp \
      third_party/icu/source/common/uhash.cpp third_party/icu/source/common/uhash_us.cpp \
      third_party/icu/source/common/uidna.cpp third_party/icu/source/common/uinit.cpp \
      third_party/icu/source/common/uinvchar.cpp third_party/icu/source/common/uiter.cpp \
      third_party/icu/source/common/ulist.cpp third_party/icu/source/common/uloc.cpp \
      third_party/icu/source/common/uloc_keytype.cpp third_party/icu/source/common/uloc_tag.cpp \
      third_party/icu/source/common/umapfile.cpp third_party/icu/source/common/umath.cpp \
      third_party/icu/source/common/umutablecptrie.cpp third_party/icu/source/common/umutex.cpp \
      third_party/icu/source/common/unames.cpp third_party/icu/source/common/unifiedcache.cpp \
      third_party/icu/source/common/unifilt.cpp third_party/icu/source/common/unifunct.cpp \
      third_party/icu/source/common/uniset.cpp third_party/icu/source/common/uniset_closure.cpp \
      third_party/icu/source/common/uniset_props.cpp third_party/icu/source/common/unisetspan.cpp \
      third_party/icu/source/common/unistr.cpp third_party/icu/source/common/unistr_case.cpp \
      third_party/icu/source/common/unistr_case_locale.cpp third_party/icu/source/common/unistr_cnv.cpp \
      third_party/icu/source/common/unistr_props.cpp third_party/icu/source/common/unistr_titlecase_brkiter.cpp \
      third_party/icu/source/common/unorm.cpp third_party/icu/source/common/unormcmp.cpp \
      third_party/icu/source/common/uobject.cpp third_party/icu/source/common/uprops.cpp \
      third_party/icu/source/common/ures_cnv.cpp third_party/icu/source/common/uresbund.cpp \
      third_party/icu/source/common/uresdata.cpp third_party/icu/source/common/usc_impl.cpp \
      third_party/icu/source/common/uscript.cpp third_party/icu/source/common/uscript_props.cpp \
      third_party/icu/source/common/uset.cpp third_party/icu/source/common/uset_props.cpp \
      third_party/icu/source/common/usetiter.cpp third_party/icu/source/common/ushape.cpp \
      third_party/icu/source/common/usprep.cpp third_party/icu/source/common/ustack.cpp \
      third_party/icu/source/common/ustr_cnv.cpp third_party/icu/source/common/ustr_titlecase_brkiter.cpp \
      third_party/icu/source/common/ustr_wcs.cpp third_party/icu/source/common/ustrcase.cpp \
      third_party/icu/source/common/ustrcase_locale.cpp third_party/icu/source/common/ustrenum.cpp \
      third_party/icu/source/common/ustrfmt.cpp third_party/icu/source/common/ustring.cpp \
      third_party/icu/source/common/ustrtrns.cpp third_party/icu/source/common/utext.cpp \
      third_party/icu/source/common/utf_impl.cpp third_party/icu/source/common/util.cpp \
      third_party/icu/source/common/util_props.cpp third_party/icu/source/common/utrace.cpp \
      third_party/icu/source/common/utrie.cpp third_party/icu/source/common/utrie2.cpp \
      third_party/icu/source/common/utrie2_builder.cpp third_party/icu/source/common/utrie_swap.cpp \
      third_party/icu/source/common/uts46.cpp third_party/icu/source/common/utypes.cpp \
      third_party/icu/source/common/uvector.cpp third_party/icu/source/common/uvectr32.cpp \
      third_party/icu/source/common/uvectr64.cpp third_party/icu/source/common/wintz.cpp"


  LIB_ICU_I18N_SOURCES="third_party/icu/source/i18n/alphaindex.cpp third_party/icu/source/i18n/anytrans.cpp \
      third_party/icu/source/i18n/astro.cpp third_party/icu/source/i18n/basictz.cpp \
      third_party/icu/source/i18n/bocsu.cpp third_party/icu/source/i18n/brktrans.cpp \
      third_party/icu/source/i18n/buddhcal.cpp third_party/icu/source/i18n/calendar.cpp \
      third_party/icu/source/i18n/casetrn.cpp third_party/icu/source/i18n/cecal.cpp \
      third_party/icu/source/i18n/chnsecal.cpp third_party/icu/source/i18n/choicfmt.cpp \
      third_party/icu/source/i18n/coleitr.cpp third_party/icu/source/i18n/coll.cpp \
      third_party/icu/source/i18n/collation.cpp third_party/icu/source/i18n/collationbuilder.cpp \
      third_party/icu/source/i18n/collationcompare.cpp third_party/icu/source/i18n/collationdata.cpp \
      third_party/icu/source/i18n/collationdatabuilder.cpp third_party/icu/source/i18n/collationdatareader.cpp \
      third_party/icu/source/i18n/collationdatawriter.cpp third_party/icu/source/i18n/collationfastlatin.cpp \
      third_party/icu/source/i18n/collationfastlatinbuilder.cpp third_party/icu/source/i18n/collationfcd.cpp \
      third_party/icu/source/i18n/collationiterator.cpp third_party/icu/source/i18n/collationkeys.cpp \
      third_party/icu/source/i18n/collationroot.cpp third_party/icu/source/i18n/collationrootelements.cpp \
      third_party/icu/source/i18n/collationruleparser.cpp third_party/icu/source/i18n/collationsets.cpp \
      third_party/icu/source/i18n/collationsettings.cpp third_party/icu/source/i18n/collationtailoring.cpp \
      third_party/icu/source/i18n/collationweights.cpp third_party/icu/source/i18n/compactdecimalformat.cpp \
      third_party/icu/source/i18n/coptccal.cpp third_party/icu/source/i18n/cpdtrans.cpp \
      third_party/icu/source/i18n/csdetect.cpp third_party/icu/source/i18n/csmatch.cpp \
      third_party/icu/source/i18n/csr2022.cpp third_party/icu/source/i18n/csrecog.cpp \
      third_party/icu/source/i18n/csrmbcs.cpp third_party/icu/source/i18n/csrsbcs.cpp \
      third_party/icu/source/i18n/csrucode.cpp third_party/icu/source/i18n/csrutf8.cpp \
      third_party/icu/source/i18n/curramt.cpp third_party/icu/source/i18n/currfmt.cpp \
      third_party/icu/source/i18n/currpinf.cpp third_party/icu/source/i18n/currunit.cpp \
      third_party/icu/source/i18n/dangical.cpp third_party/icu/source/i18n/datefmt.cpp \
      third_party/icu/source/i18n/dayperiodrules.cpp third_party/icu/source/i18n/dcfmtsym.cpp \
      third_party/icu/source/i18n/decContext.cpp third_party/icu/source/i18n/decNumber.cpp \
      third_party/icu/source/i18n/decimfmt.cpp third_party/icu/source/i18n/double-conversion-bignum-dtoa.cpp \
      third_party/icu/source/i18n/double-conversion-bignum.cpp third_party/icu/source/i18n/double-conversion-cached-powers.cpp \
      third_party/icu/source/i18n/double-conversion-double-to-string.cpp third_party/icu/source/i18n/double-conversion-fast-dtoa.cpp \
      third_party/icu/source/i18n/double-conversion-string-to-double.cpp third_party/icu/source/i18n/double-conversion-strtod.cpp \
      third_party/icu/source/i18n/dtfmtsym.cpp third_party/icu/source/i18n/dtitvfmt.cpp \
      third_party/icu/source/i18n/dtitvinf.cpp third_party/icu/source/i18n/dtptngen.cpp \
      third_party/icu/source/i18n/dtrule.cpp third_party/icu/source/i18n/erarules.cpp \
      third_party/icu/source/i18n/esctrn.cpp third_party/icu/source/i18n/ethpccal.cpp \
      third_party/icu/source/i18n/fmtable.cpp third_party/icu/source/i18n/fmtable_cnv.cpp \
      third_party/icu/source/i18n/format.cpp third_party/icu/source/i18n/formatted_string_builder.cpp \
      third_party/icu/source/i18n/formattedval_iterimpl.cpp third_party/icu/source/i18n/formattedval_sbimpl.cpp \
      third_party/icu/source/i18n/formattedvalue.cpp third_party/icu/source/i18n/fphdlimp.cpp \
      third_party/icu/source/i18n/fpositer.cpp third_party/icu/source/i18n/funcrepl.cpp \
      third_party/icu/source/i18n/gender.cpp third_party/icu/source/i18n/gregocal.cpp \
      third_party/icu/source/i18n/gregoimp.cpp third_party/icu/source/i18n/hebrwcal.cpp \
      third_party/icu/source/i18n/indiancal.cpp third_party/icu/source/i18n/inputext.cpp \
      third_party/icu/source/i18n/islamcal.cpp third_party/icu/source/i18n/japancal.cpp \
      third_party/icu/source/i18n/listformatter.cpp third_party/icu/source/i18n/measfmt.cpp \
      third_party/icu/source/i18n/measunit.cpp third_party/icu/source/i18n/measunit_extra.cpp \
      third_party/icu/source/i18n/measure.cpp third_party/icu/source/i18n/msgfmt.cpp \
      third_party/icu/source/i18n/name2uni.cpp third_party/icu/source/i18n/nfrs.cpp \
      third_party/icu/source/i18n/nfrule.cpp third_party/icu/source/i18n/nfsubs.cpp \
      third_party/icu/source/i18n/nortrans.cpp third_party/icu/source/i18n/nultrans.cpp \
      third_party/icu/source/i18n/number_affixutils.cpp third_party/icu/source/i18n/number_asformat.cpp \
      third_party/icu/source/i18n/number_capi.cpp third_party/icu/source/i18n/number_compact.cpp \
      third_party/icu/source/i18n/number_currencysymbols.cpp third_party/icu/source/i18n/number_decimalquantity.cpp \
      third_party/icu/source/i18n/number_decimfmtprops.cpp third_party/icu/source/i18n/number_fluent.cpp \
      third_party/icu/source/i18n/number_formatimpl.cpp third_party/icu/source/i18n/number_grouping.cpp \
      third_party/icu/source/i18n/number_integerwidth.cpp third_party/icu/source/i18n/number_longnames.cpp \
      third_party/icu/source/i18n/number_mapper.cpp third_party/icu/source/i18n/number_modifiers.cpp \
      third_party/icu/source/i18n/number_multiplier.cpp third_party/icu/source/i18n/number_notation.cpp \
      third_party/icu/source/i18n/number_output.cpp third_party/icu/source/i18n/number_padding.cpp \
      third_party/icu/source/i18n/number_patternmodifier.cpp third_party/icu/source/i18n/number_patternstring.cpp \
      third_party/icu/source/i18n/number_rounding.cpp third_party/icu/source/i18n/number_scientific.cpp \
      third_party/icu/source/i18n/number_skeletons.cpp third_party/icu/source/i18n/number_symbolswrapper.cpp \
      third_party/icu/source/i18n/number_usageprefs.cpp third_party/icu/source/i18n/number_utils.cpp \
      third_party/icu/source/i18n/numfmt.cpp third_party/icu/source/i18n/numparse_affixes.cpp \
      third_party/icu/source/i18n/numparse_compositions.cpp third_party/icu/source/i18n/numparse_currency.cpp \
      third_party/icu/source/i18n/numparse_decimal.cpp third_party/icu/source/i18n/numparse_impl.cpp \
      third_party/icu/source/i18n/numparse_parsednumber.cpp third_party/icu/source/i18n/numparse_scientific.cpp \
      third_party/icu/source/i18n/numparse_symbols.cpp third_party/icu/source/i18n/numparse_validators.cpp \
      third_party/icu/source/i18n/numrange_capi.cpp third_party/icu/source/i18n/numrange_fluent.cpp \
      third_party/icu/source/i18n/numrange_impl.cpp third_party/icu/source/i18n/numsys.cpp \
      third_party/icu/source/i18n/olsontz.cpp third_party/icu/source/i18n/persncal.cpp \
      third_party/icu/source/i18n/pluralranges.cpp third_party/icu/source/i18n/plurfmt.cpp \
      third_party/icu/source/i18n/plurrule.cpp third_party/icu/source/i18n/quant.cpp \
      third_party/icu/source/i18n/quantityformatter.cpp third_party/icu/source/i18n/rbnf.cpp \
      third_party/icu/source/i18n/rbt.cpp third_party/icu/source/i18n/rbt_data.cpp \
      third_party/icu/source/i18n/rbt_pars.cpp third_party/icu/source/i18n/rbt_rule.cpp \
      third_party/icu/source/i18n/rbt_set.cpp third_party/icu/source/i18n/rbtz.cpp \
      third_party/icu/source/i18n/regexcmp.cpp third_party/icu/source/i18n/regeximp.cpp \
      third_party/icu/source/i18n/regexst.cpp third_party/icu/source/i18n/regextxt.cpp \
      third_party/icu/source/i18n/region.cpp third_party/icu/source/i18n/reldatefmt.cpp \
      third_party/icu/source/i18n/reldtfmt.cpp third_party/icu/source/i18n/rematch.cpp \
      third_party/icu/source/i18n/remtrans.cpp third_party/icu/source/i18n/repattrn.cpp \
      third_party/icu/source/i18n/rulebasedcollator.cpp third_party/icu/source/i18n/scientificnumberformatter.cpp \
      third_party/icu/source/i18n/scriptset.cpp third_party/icu/source/i18n/search.cpp \
      third_party/icu/source/i18n/selfmt.cpp third_party/icu/source/i18n/sharedbreakiterator.cpp \
      third_party/icu/source/i18n/simpletz.cpp third_party/icu/source/i18n/smpdtfmt.cpp \
      third_party/icu/source/i18n/smpdtfst.cpp third_party/icu/source/i18n/sortkey.cpp \
      third_party/icu/source/i18n/standardplural.cpp third_party/icu/source/i18n/string_segment.cpp \
      third_party/icu/source/i18n/strmatch.cpp third_party/icu/source/i18n/strrepl.cpp \
      third_party/icu/source/i18n/stsearch.cpp third_party/icu/source/i18n/taiwncal.cpp \
      third_party/icu/source/i18n/timezone.cpp third_party/icu/source/i18n/titletrn.cpp \
      third_party/icu/source/i18n/tmunit.cpp third_party/icu/source/i18n/tmutamt.cpp \
      third_party/icu/source/i18n/tmutfmt.cpp third_party/icu/source/i18n/tolowtrn.cpp \
      third_party/icu/source/i18n/toupptrn.cpp third_party/icu/source/i18n/translit.cpp \
      third_party/icu/source/i18n/transreg.cpp third_party/icu/source/i18n/tridpars.cpp \
      third_party/icu/source/i18n/tzfmt.cpp third_party/icu/source/i18n/tzgnames.cpp \
      third_party/icu/source/i18n/tznames.cpp third_party/icu/source/i18n/tznames_impl.cpp \
      third_party/icu/source/i18n/tzrule.cpp third_party/icu/source/i18n/tztrans.cpp \
      third_party/icu/source/i18n/ucal.cpp third_party/icu/source/i18n/ucln_in.cpp \
      third_party/icu/source/i18n/ucol.cpp third_party/icu/source/i18n/ucol_res.cpp \
      third_party/icu/source/i18n/ucol_sit.cpp third_party/icu/source/i18n/ucoleitr.cpp \
      third_party/icu/source/i18n/ucsdet.cpp third_party/icu/source/i18n/udat.cpp \
      third_party/icu/source/i18n/udateintervalformat.cpp third_party/icu/source/i18n/udatpg.cpp \
      third_party/icu/source/i18n/ufieldpositer.cpp third_party/icu/source/i18n/uitercollationiterator.cpp \
      third_party/icu/source/i18n/ulistformatter.cpp third_party/icu/source/i18n/ulocdata.cpp \
      third_party/icu/source/i18n/umsg.cpp third_party/icu/source/i18n/unesctrn.cpp \
      third_party/icu/source/i18n/uni2name.cpp third_party/icu/source/i18n/units_complexconverter.cpp \
      third_party/icu/source/i18n/units_converter.cpp third_party/icu/source/i18n/units_data.cpp \
      third_party/icu/source/i18n/units_router.cpp third_party/icu/source/i18n/unum.cpp \
      third_party/icu/source/i18n/unumsys.cpp third_party/icu/source/i18n/upluralrules.cpp \
      third_party/icu/source/i18n/uregex.cpp third_party/icu/source/i18n/uregexc.cpp \
      third_party/icu/source/i18n/uregion.cpp third_party/icu/source/i18n/usearch.cpp \
      third_party/icu/source/i18n/uspoof.cpp third_party/icu/source/i18n/uspoof_build.cpp \
      third_party/icu/source/i18n/uspoof_conf.cpp third_party/icu/source/i18n/uspoof_impl.cpp \
      third_party/icu/source/i18n/utf16collationiterator.cpp third_party/icu/source/i18n/utf8collationiterator.cpp \
      third_party/icu/source/i18n/utmscale.cpp third_party/icu/source/i18n/utrans.cpp \
      third_party/icu/source/i18n/vtzone.cpp third_party/icu/source/i18n/vzone.cpp \
      third_party/icu/source/i18n/windtfmt.cpp third_party/icu/source/i18n/winnmfmt.cpp \
      third_party/icu/source/i18n/wintzimpl.cpp third_party/icu/source/i18n/zonemeta.cpp \
      third_party/icu/source/i18n/zrule.cpp third_party/icu/source/i18n/ztrans.cpp"

  LIB_HARFBUZZ_SOURCES="third_party/harfbuzz-ng/src/hb-aat-layout.cc third_party/harfbuzz-ng/src/hb-aat-map.cc third_party/harfbuzz-ng/src/hb-blob.cc\
	  third_party/harfbuzz-ng/src/hb-buffer-serialize.cc third_party/harfbuzz-ng/src/hb-buffer.cc third_party/harfbuzz-ng/src/hb-common.cc third_party/harfbuzz-ng/src/hb-coretext.cc third_party/harfbuzz-ng/src/hb-directwrite.cc\
	  third_party/harfbuzz-ng/src/hb-draw.cc third_party/harfbuzz-ng/src/hb-face.cc third_party/harfbuzz-ng/src/hb-fallback-shape.cc third_party/harfbuzz-ng/src/hb-font.cc third_party/harfbuzz-ng/src/hb-ft.cc third_party/harfbuzz-ng/src/hb-gdi.cc third_party/harfbuzz-ng/src/hb-glib.cc\
	  third_party/harfbuzz-ng/src/hb-gobject-structs.cc third_party/harfbuzz-ng/src/hb-graphite2.cc third_party/harfbuzz-ng/src/hb-icu.cc third_party/harfbuzz-ng/src/hb-map.cc third_party/harfbuzz-ng/src/hb-number.cc third_party/harfbuzz-ng/src/hb-ot-cff1-table.cc\
	  third_party/harfbuzz-ng/src/hb-ot-cff2-table.cc third_party/harfbuzz-ng/src/hb-ot-color.cc third_party/harfbuzz-ng/src/hb-ot-face.cc third_party/harfbuzz-ng/src/hb-ot-font.cc third_party/harfbuzz-ng/src/hb-ot-layout.cc third_party/harfbuzz-ng/src/hb-ot-map.cc\
	  third_party/harfbuzz-ng/src/hb-ot-math.cc third_party/harfbuzz-ng/src/hb-ot-meta.cc third_party/harfbuzz-ng/src/hb-ot-metrics.cc third_party/harfbuzz-ng/src/hb-ot-name.cc third_party/harfbuzz-ng/src/hb-ot-shape-complex-arabic.cc\
	  third_party/harfbuzz-ng/src/hb-ot-shape-complex-default.cc third_party/harfbuzz-ng/src/hb-ot-shape-complex-hangul.cc third_party/harfbuzz-ng/src/hb-ot-shape-complex-hebrew.cc\
	  third_party/harfbuzz-ng/src/hb-ot-shape-complex-indic-table.cc third_party/harfbuzz-ng/src/hb-ot-shape-complex-indic.cc third_party/harfbuzz-ng/src/hb-ot-shape-complex-khmer.cc\
	  third_party/harfbuzz-ng/src/hb-ot-shape-complex-myanmar.cc third_party/harfbuzz-ng/src/hb-ot-shape-complex-thai.cc third_party/harfbuzz-ng/src/hb-ot-shape-complex-use-table.cc\
	  third_party/harfbuzz-ng/src/hb-ot-shape-complex-use.cc third_party/harfbuzz-ng/src/hb-ot-shape-complex-vowel-constraints.cc third_party/harfbuzz-ng/src/hb-ot-shape-fallback.cc\
	  third_party/harfbuzz-ng/src/hb-ot-shape-normalize.cc third_party/harfbuzz-ng/src/hb-ot-shape.cc third_party/harfbuzz-ng/src/hb-ot-tag.cc third_party/harfbuzz-ng/src/hb-ot-var.cc third_party/harfbuzz-ng/src/hb-set.cc third_party/harfbuzz-ng/src/hb-shape-plan.cc\
	  third_party/harfbuzz-ng/src/hb-shape.cc third_party/harfbuzz-ng/src/hb-shaper.cc third_party/harfbuzz-ng/src/hb-static.cc third_party/harfbuzz-ng/src/hb-style.cc third_party/harfbuzz-ng/src/hb-subset-cff-common.cc third_party/harfbuzz-ng/src/hb-subset-cff1.cc\
	  third_party/harfbuzz-ng/src/hb-subset-cff2.cc third_party/harfbuzz-ng/src/hb-subset-input.cc third_party/harfbuzz-ng/src/hb-subset-plan.cc third_party/harfbuzz-ng/src/hb-subset.cc third_party/harfbuzz-ng/src/hb-ucd.cc third_party/harfbuzz-ng/src/hb-unicode.cc third_party/harfbuzz-ng/src/hb-uniscribe.cc"


  THIRD_PARTY_SOURCES="$LIB_ICU_SOURCES $LIB_ICU_I18N_SOURCES $LIB_HARFBUZZ_SOURCES"

  PHP_EXT_CXX_SOURCES="$THIRD_PARTY_SOURCES utils/icu_util.cc utils/hb_util.cc"

  PHP_EXT_SOURCES="$PHP_EXT_CXX_SOURCES fontkit.cc font_php_class.cc blob_php_class.cc"

  LIB_ICU_CXX_FLAGS="-DU_USING_ICU_NAMESPACE=0 -DU_ENABLE_DYLOAD=0 -DU_ENABLE_TRACING=1 -DU_ENABLE_RESOURCE_TRACING=0 \
		-DICU_UTIL_DATA_IMPL=ICU_UTIL_DATA_FILE -DUCHAR_TYPE=uint16_t -DUCONFIG_ONLY_HTML_CONVERSION=1 -DUCONFIG_USE_WINDOWS_LCID_MAPPING_API=0 \
		-DU_CHARSET_IS_UTF8=1 -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_ICUDATAENTRY_IN_COMMON \
		-DU_I18N_IMPLEMENTATION -Wno-unused-function -Wno-deprecated-declarations"
  if test "$CLANG" = "yes"; then
    LIB_ICU_CXX_FLAGS="$LIB_ICU_CXX_FLAGS -Wno-parentheses -Wno-unused-function -Wno-unused-variable"
  fi

  LIB_HARFBUZZ_CXX_FLAGS="-DHAVE_ICU -DHAVE_ICU_BUILTIN -DHAVE_INTEL_ATOMIC_PRIMITIVES -DHAVE_ROUNDF -DHB_NO_MMAP -DHB_NO_RESOURCE_FORK \
        -DHB_NO_FALLBACK_SHAPE -DHB_NO_UCD -DHB_NO_WIN1256 -DHB_EXPERIMENTAL_API"

  PHP_EXT_CXX_FLAGS="-DZEND_ENABLE_STATIC_TSRMLS_CACHE=1"
  EXT_C_FLAGS="$LIB_ICU_CXX_FLAGS $LIB_HARFBUZZ_CXX_FLAGS $PHP_EXT_CXX_FLAGS"

  PHP_CXX_COMPILE_STDCXX(11, mandatory, EXT_STDCXX_SWiTCH)
  EXT_CXX_FLAGS="$EXT_C_FLAGS $EXT_STDCXX_SWiTCH"

  if test "$PHP_CXX_SHARED_MODULE" != "no"; then
    PHP_NEW_EXTENSION(fontkit, $PHP_EXT_SOURCES, $ext_shared,, $EXT_CXX_FLAGS, cxx)
  else
    PHP_NEW_EXTENSION(fontkit, $PHP_EXT_SOURCES, $ext_shared,, $EXT_CXX_FLAGS)
  fi

fi
