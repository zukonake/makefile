SOURCE_DIR = src
OBJ_DIR = bin
DOC_DIR = doc
DEPEND_DIR = depend
INCLUDE_DIR = include
LIB_DIR = lib

TEST_DIR = test

VERSION_STAGE = alpha
VERSION_MAJOR = 0
VERSION_MINOR = 0
VERSION_PATCH = 0

BASE_NAME = projectname
TARGET = lib$(BASE_NAME)-$(VERSION_MAJOR)-$(VERSION_MINOR)-$(VERSION_PATCH)-$(VERSION_STAGE).so
TARGET_LINK = lib$(BASE_NAME).so
BASE_NAME_DEFINE = $(shell echo $(BASE_NAME) | tr '[:lower:]' '[:upper:]')

CPP_FILES = $(shell find $(SOURCE_DIR) -type f -name "*.cpp" -printf '%p ')
OBJ_FILES = $(addprefix $(OBJ_DIR)/,$(patsubst %.cpp,%.o,$(notdir $(CPP_FILES))))

VERSION_FLAGS=-D$(BASE_NAME_DEFINE)_VERSION_STAGE="$(VERSION_STAGE)" -D$(BASE_NAME_DEFINE)_VERSION_MAJOR="$(VERSION_MAJOR)" -D$(BASE_NAME_DEFINE)_VERSION_MINOR="$(VERSION_MINOR)" -D$(BASE_NAME_DEFINE)_VERSION_PATCH="$(VERSION_PATCH)"
DEBUG_FLAGS = -g -O0 -DDEBUG
WARNING_FLAGS = -Wall -Wextra
STD = --std=c++11
INCLUDES = -I $(SOURCE_DIR) -I $(INCLUDE_DIR)
LDLIBS = 
LDFLAGS = $(INCLUDES) $(STD) -shared -fPIC $(WARNING_FLAGS) $(DEBUG_FLAGS) -L $(LIB_DIR) $(VERSION_FLAGS)
CXXLAGS = $(INCLUDES) $(STD) -fPIC $(WARNING_FLAGS) $(DEBUG_FLAGS) $(VERSION_FLAGS)

PREFIX = /usr/lib
DOXYFILE = Doxyfile

.PHONY : clean install uninstall test doc

$(TARGET) : $(OBJ_FILES)
	$(CXX) $(LDFLAGS) $(OBJ_FILES) -o $@

.SECONDEXPANSION:
$(OBJ_DIR)/%.o : $$(shell find $(SOURCE_DIR) -type f -name %.cpp)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(DEPEND_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@
	$(CXX) $(CXXFLAGS) -MM $< > $(DEPEND_DIR)/$*.d
	@sed -i '1s/^/$(OBJ_DIR)\//' $(DEPEND_DIR)/$*.d

install: $(TARGET)
	install -m 755 $(TARGET) $(PREFIX)/$(TARGET)
	ln -sf $(PREFIX)/$(TARGET) $(PREXIX)/$(TARGET_LINK)

uninstall:
	$(RM) -f $(PREFIX)/$(TARGET) $(PREFIX)/$(TARGET_LINK)

clean :
	$(RM) -r $(OBJ_DIR) $(DEPEND_DIR) $(TARGET) $(DOC_DIR)

test :
	make -C ./$(TEST_DIR)

doc :
	@mkdir -p $(DOC_DIR)
	doxygen $(DOXYFILE)

-include $(subst $(OBJ_DIR)/,$(DEPEND_DIR)/,$(patsubst %.o,%.d,$(OBJ_FILES)))
