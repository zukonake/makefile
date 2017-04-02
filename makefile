SOURCE_DIR = src
INCLUDE_DIR = include
OBJ_DIR = bin
DOC_DIR = doc
DEPEND_DIR = depend
TEST_DIR = test

TARGET = libluna-2.0.0-alpha.so
TARGET_LINK = libluna.so

VERSION_MAJOR = 2
VERSION_MINOR = 0
VERSION_PATCH = 0

CPP_FILES = $(shell find $(SOURCE_DIR) -path $(SOURCE_DIR)/$(TEST_DIR) -prune -o -type f -name "*.cpp" -printf '%p ')
OBJ_FILES = $(addprefix $(OBJ_DIR)/,$(patsubst %.cpp,%.o,$(notdir $(CPP_FILES))))

TEST_CPP_FILES = $(shell find $(SOURCE_DIR)/$(TEST_DIR) -type f -name "*.cpp" -printf '%p ')
TEST_OBJ_FILES = $(addprefix $(OBJ_DIR)/,$(patsubst %.cpp,%.o,$(notdir $(TEST_CPP_FILES))))

LIBS = -llua -lboost_unit_test_framework
DEBUG_FLAGS = -g -O0 -DDEBUG
WARNING_FLAGS = -Wall -Wextra
INCLUDE_FLAGS = -I include
LIB_FLAGS =
COMPILER = g++
COMPILER_FLAGS = -std=c++17 -fPIC $(WARNING_FLAGS) $(DEBUG_FLAGS) $(INCLUDE_FLAGS)

COMPILE = $(COMPILER) $(COMPILER_FLAGS)
LINK = $(COMPILER) $(COMPILER_FLAGS) $(LIBS) $(LIB_FLAGS) $(OBJ_FILES)

PREFIX = /usr/lib
DOXYFILE = Doxyfile

.PHONY : clean install uninstall test doc

$(TARGET) : $(OBJ_FILES)
	$(LINK) -shared -o $@

test: $(TEST_OBJ_FILES) $(OBJ_FILES)
	$(LINK) $(TEST_OBJ_FILES) -o $@.out

.SECONDEXPANSION:
$(OBJ_DIR)/%.o : $$(shell find $(SOURCE_DIR) -type f -name %.cpp)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(DEPEND_DIR)
	$(COMPILE) -c $< -o $@
	$(COMPILE) -MM $< > $(DEPEND_DIR)/$*.d
	@sed -i '1s/^/$(OBJ_DIR)\//' $(DEPEND_DIR)/$*.d

install: $(TARGET)
	install -m 755 $(TARGET) $(PREFIX)/$(TARGET)
	ln -sf $(PREFIX)/$(TARGET) $(PREXIX)/$(TARGET_LINK)

uninstall:
	rm -f $(PREFIX)/$(TARGET) $(PREFIX)/$(TARGET_LINK)

clean :
	$(RM) -r $(OBJ_DIR) $(DEPEND_DIR) $(TARGET) test.out $(DOC_DIR)

doc :
	@mkdir -p $(DOC_DIR)
	doxygen $(DOXYFILE)

-include $(subst $(OBJ_DIR)/,,$(patsubst %.o,%.d,$(OBJ_FILES)))
