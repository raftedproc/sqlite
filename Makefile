TARGET = sqlite3
CC = /wasi-sdk-15.0/bin/clang
SYSROOT = /wasi-sdk-15.0/share/wasi-sysroot
TARGET_TRIPLE = wasm32-wasi
CFLAGS = -fvisibility=hidden
SDK = sdk/logger.h
LDFLAGS = -Wl,--demangle,--allow-undefined
EXPORT_FUNCS = \
	--export=allocate,$\
	--export=release_objects,$\
	--export=set_result_size,$\
	--export=set_result_ptr,$\
	--export=get_result_size,$\
	--export=get_result_ptr,$\
	--export=sqlite3_open_v2_,$\
	--export=sqlite3_close,$\
	--export=sqlite3_prepare_v2_,$\
	--export=sqlite3_exec_,$\
	--export=sqlite3_libversion_number,$\
	--export=sqlite3_total_changes,$\
	--export=sqlite3_changes,$\
	--export=sqlite3_busy_timeout,$\
	--export=sqlite3_errmsg_,$\
	--export=sqlite3_errcode,$\
	--export=sqlite3_column_type,$\
	--export=sqlite3_column_name_,$\
	--export=sqlite3_step,$\
	--export=sqlite3_reset,$\
	--export=sqlite3_bind_blob,$\
	--export=sqlite3_bind_double,$\
	--export=sqlite3_bind_int64,$\
	--export=sqlite3_bind_text,$\
	--export=sqlite3_bind_null,$\
	--export=sqlite3_column_count,$\
	--export=sqlite3_column_double,$\
	--export=sqlite3_column_int64,$\
	--export=sqlite3_column_blob_,$\
	--export=sqlite3_column_bytes,$\
	--export=sqlite3_finalize
SQLITE_SRC = \
	src/alter.c\
	src/analyze.c\
	src/attach.c\
	src/auth.c\
	src/backup.c\
	src/bitvec.c\
	src/btmutex.c\
	src/btree.c\
	src/build.c\
	src/callback.c\
	src/complete.c\
	src/ctime.c\
	src/date.c\
	src/demo_os.c\
	src/demo_vfs.c\
	src/dbpage.c\
	src/dbstat.c\
	src/delete.c\
	src/expr.c\
	src/fault.c\
	src/fkey.c\
	src/fts3.c\
	src/fts3_write.c\
	src/fts3_aux.c\
	src/fts3_expr.c\
	src/fts3_hash.c\
	src/fts3_icu.c\
	src/fts3_porter.c\
	src/fts3_snippet.c\
	src/fts3_tokenize_vtab.c\
	src/fts3_tokenizer.c\
	src/fts3_tokenizer1.c\
	src/fts3_unicode.c\
	src/fts3_unicode2.c\
	src/fts5.c\
	src/func.c\
	src/global.c\
	src/hash.c\
	src/insert.c\
  	src/json.c\
	src/legacy.c\
	src/loadext.c\
	src/main.c\
	src/malloc.c\
	src/memdb.c\
	src/mem0.c\
	src/mem1.c\
	src/mem2.c\
	src/memjournal.c\
	src/notify.c\
	src/opcodes.c\
	src/os.c\
	src/pager.c\
	src/parse.c\
	src/pcache.c\
	src/pcache1.c\
	src/pragma.c\
	src/prepare.c\
	src/printf.c\
	src/random.c\
	src/resolve.c\
	src/rowset.c\
	src/rtree.c\
	src/select.c\
	src/sqlite3session.c\
	src/status.c\
	src/stmt.c\
	src/table.c\
	src/tokenize.c\
	src/treeview.c\
	src/trigger.c\
	src/update.c\
	src/upsert.c\
	src/userauth.c\
	src/utf.c\
	src/util.c\
	src/vacuum.c\
	src/vdbe.c\
	src/vdbeapi.c\
	src/vdbeaux.c\
	src/vdbeblob.c\
	src/vdbemem.c\
	src/vdbesort.c\
	src/vdbetrace.c\
  	src/vdbevtab.c\
	src/vtab.c\
	src/wal.c\
	src/walker.c\
	src/where.c\
	src/wherecode.c\
	src/whereexpr.c\
	src/window.c
WRAPPER_SRC = src/wrapper.c
SQLITE_FLAGS = \
	-DSQLITE_CORE\
	-D_HAVE_SQLITE_CONFIG_H\
	-DENABLE_LOG\
	-DBUILD_sqlite\
	-DNDEBUG\
	-DSQLITE_OS_UNIX\
	-DSQLITE_THREADSAFE=0\
	-DHAVE_READLINE=0\
	-DHAVE_EDITLINE=0\
	-DSQLITE_OMIT_LOAD_EXTENSION\
	-DSQLITE_ENABLE_FTS5\
	-DSQLITE_ENABLE_RTREE\
	-DSQLITE_ENABLE_EXPLAIN_COMMENTS\
	-DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION\
	-DSQLITE_ENABLE_STMTVTAB\
	-DSQLITE_ENABLE_DBPAGE_VTAB\
	-DSQLITE_ENABLE_DBSTAT_VTAB\
	-DSQLITE_ENABLE_OFFSET_SQL_FUNC\
	-DSQLITE_ENABLE_DESERIALIZE\
	-DSQLITE_INTROSPECTION_PRAGMAS\
	-DSQLITE_OMIT_POPEN\
	-DCVECTOR_LOGARITHMIC_GROWTH

.PHONY: default all clean

default: $(TARGET)
all: default

$(TARGET): $(SQLITE_SRC) $(WRAPPER_SRC)
	$(CC) -O3 --sysroot=$(SYSROOT) --target=$(TARGET_TRIPLE) $(SQLITE_FLAGS) $(CFLAGS) $(LDFLAGS) -Wl,$(EXPORT_FUNCS) $^ -o $@.wasm
	/root/.cargo/bin/marine set version -i ./sqlite3.wasm -v 0.7.0
	/root/.cargo/bin/marine set it -i ./sqlite3.wasm -w sqlite3.wit

.PRECIOUS: $(TARGET)

clean:
	-rm -f $(TARGET).wasm $(TARGET).wat
